import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_plugin_qpos/QPOSModel.dart';
import 'package:flutter_plugin_qpos/flutter_plugin_qpos.dart';
import 'package:injectable/injectable.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:cliff_pickleball/services/cacheService.dart';
import 'package:cliff_pickleball/utils/translate.dart';

import '../../services/http/api_services.dart';
import '../../services/http/result.dart';
import '../../styles/theme_selector.dart';
import 'ble_perms_check.dart';
import 'domain/device.dart';
import 'location_perms_check.dart';

part 'bluetooth_scan_event.dart';
part 'bluetooth_scan_state.dart';

@injectable
class BluetoothScanBloc extends Bloc<BluetoothScanEvent, BluetoothScanState> {
  final _logger = Logger();

  final _flutterPluginQpos = FlutterPluginQpos();

  bool _pendingDeviceScan = false;

  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;

  DeviceBluetooth? _mydevice;
  String? error;
  bool _isBluetoothEnabled = false;
  bool _manualDisconnection = false;
  final _devices = <DeviceBluetooth>{};

  CommunicationMode? communicationMode;

  StreamSubscription<QPOSModel>? _subscription;
  StreamSubscription<BluetoothState>? _bleSubscription;

  final Cache _cache;
  final ApiServices _apiServices;
  final ThemeSelector _themeSelector;
  final BlePermsCheck _blePermsCheck;
  final LocationPermsCheck _locationPermsCheck;

  BluetoothScanBloc(this._cache, this._apiServices, this._themeSelector,
      this._blePermsCheck, this._locationPermsCheck)
      : super(const BluetoothScanInitial()) {
    on<BluetoothScanEvent>((event, emit) async {
      _logger.i(
          "event ${event.runtimeType} _isBluetoothEnabled $_isBluetoothEnabled");
      switch (event.runtimeType) {
        case BluetoothScanInitEvent:
          init();
          break;
        case BluetoothScanBleModeSelectedEvent:
          _changeBleMode((event as BluetoothScanBleModeSelectedEvent).mode);
          add(const BluetoothScanInitEvent());
          break;
        case StartBluetoothScanEvent:
          if (_mydevice != null) {
            _disconnect();
          }

          _scan();
          break;
        case BluetoothDeviceOnDeviceFoundEvent:
          if (_mydevice == null) {
            emit(BluetoothDeviceScanningState(_devices, false));
          } else {
            _logger.i(_mydevice);
          }
          break;
        case BluetoothDeviceScanFinishedEvent:
          if (_mydevice == null) {
            emit(BluetoothDeviceScanningState(_devices, true));
          } else {
            _logger.i(_mydevice);
          }
          break;
        case BluetoothDeviceScanErrorEvent:
          emit(ErrorState(
              _mydevice, (event as BluetoothDeviceScanErrorEvent).error));
          break;
        case BluetoothDeviceConnectEvent:
          _deviceConnected((event as BluetoothDeviceConnectEvent).device);
          break;
        case BluetoothDeviceConnectingEvent:
          emit(BluetoothDeviceConnectingState(_mydevice!));
          break;
        case BluetoothDeviceConnectedEvent:
          emit(BluetoothDeviceConnectingState(_mydevice!));
          var result = await _loadDeviceInfo(_mydevice!.id!);
          if (_mydevice != null) {
            emit(BluetoothDeviceConnectedState(_mydevice!, result: result));
          }
          break;
        case StartBluetoothSelectCommunicationModeEvent:
          emit(
              StartBluetoothSelectCommunicationModeState(_communicationMode()));
          break;
        case BluetoothDeviceDisconnectEvent:
          _disconnect();
          break;
      }
    });
  }

  void init() async {
    var deviceBluetooth = await _cache.getQpos();
    if (deviceBluetooth != null) {
      add(BluetoothDeviceConnectEvent(deviceBluetooth));
      /*_mydevice = deviceBluetooth;
      add(const BluetoothDeviceConnectedEvent());*/
    } else {
      var communicationMode = await _cache.getBleCommunicationMode();
      if (communicationMode == null) {
        _changeBleMode(_communicationMode());
        //_turnOnForTheFirstTime = true;
      }

      _devices.clear();
      _subscription?.cancel();
      _subscription =
          _flutterPluginQpos.onPosListenerCalled!.listen(_solveQPOSModel);
      //getDeviceConnected();
      _scan();
    }
  }

  void _changeBleMode(CommunicationMode mode) {
    communicationMode = mode;
    _cache.saveBleCommunicationMode(mode);
  }

  CommunicationMode _communicationMode() {
    return communicationMode ?? CommunicationMode.BLUETOOTH;
  }

  void _streamBluetooth() async {
    _bleSubscription?.cancel();
    _bleSubscription = flutterBlue.state.listen((state) {
      _logger.i("BLE STATE $state");
      var isOn = state == BluetoothState.on;

      if (_isBluetoothEnabled && !isOn) {
        _devices.clear();
        add(const BluetoothDeviceScanFinishedEvent());
      }

      _isBluetoothEnabled = isOn;

      if (_pendingDeviceScan && _isBluetoothEnabled) {
        _pendingDeviceScan = false;
        _scanDevices();
      } else {
        if (state != BluetoothState.turningOn) {
          // _pendingDeviceScan = false;
        }
      }

      if (state == BluetoothState.off) {
        _disconnectDevice();
      }
    });
  }

  void _deviceConnected(DeviceBluetooth device) {
    _mydevice = device;
    add(const BluetoothDeviceConnectingEvent());
    _logger.i("CONNECTING TO ${device.name} ${device.macAddress}");
    _flutterPluginQpos.connectBluetoothDevice(device.macAddress);
  }

  void _scan() async {
    var result = await _locationPermsCheck.checkLocation();

    if (result.status == PermissionStatus.denied) {
      add(const BluetoothDeviceScanErrorEvent("Permiso de gps esta denegado"));
    }

    if (result.status == PermissionStatus.deniedForever) {
      add(const BluetoothDeviceScanErrorEvent(
          "Permiso de gps esta deshabilitado"));
    }

    var isLocationActivated = result.success;
    _logger.i("isLocationActivated $isLocationActivated");
    if (isLocationActivated) {
      _checkBluetooth();
    }
  }

  void _scanDevices() {
    //disconnect();
    _mydevice = null;
    add(const BluetoothDeviceOnDeviceFoundEvent());
    _flutterPluginQpos.init(_communicationMode().name);
    _logger.i("COMMUNICATION_MODE $communicationMode");
    _flutterPluginQpos.scanQPos2Mode(10);
  }

  void _checkBluetooth() async {
    _devices.clear();
    var isAvailable = await flutterBlue.isAvailable;

    _logger.i("bleIsOn ${await flutterBlue.isOn}  isAvailable $isAvailable ");

    if (isAvailable) {
      var errorMsg = await _blePermsCheck.checkBlePermissions();

      if (errorMsg.isNotEmpty) {
        add(BluetoothDeviceScanErrorEvent(errorMsg));
        return;
      }

      _streamBluetooth();

      var bleIsOn = await flutterBlue.isOn;
      if (!bleIsOn) {
        var turnOn = await flutterBlue.turnOn();
        if (!turnOn) {
          _pendingDeviceScan = true;
          _logger.i("Error al prender BLE");
          _scanDevices();
          //add(const BluetoothDeviceScanErrorEvent("Error al prender BLE"));
        } else {
          _pendingDeviceScan = true;
        }
      } else {
        _scanDevices();
      }
    } else {
      add(const BluetoothDeviceScanErrorEvent(
          "El dispositivo no tiene disponible el bluetooth"));
    }
  }

  Future<Result<String>> _loadDeviceInfo(String id) async {
    var result = await _apiServices
        .mdevice(id)
        .onError((error, stackTrace) => Result.fail(error, stackTrace));
    if (result.success) {
      if (result.obj != null) {
        Map<String, dynamic> json = jsonDecode(result.obj!);
        if (json.containsKey("device")) {
          _themeSelector.setThemeFromDeviceJson(json);
          await _cache.setMerchantDevice(json);
          _logger.i("estas guardando la data device");
          return result;
        }
      }
    }
    return result;
  }

  void _solveQPOSModel(QPOSModel qposModel) {
    var method = qposModel.method;

    List<String> paras = List.empty();
    //String parameters = map["parameters"];
    String? parameters = qposModel.parameters;
    if (parameters != null && parameters.isNotEmpty) {
      paras = parameters.split("//");
    }

    _logger.i("QPOSMODEL $qposModel method $method parameters $parameters");
    if (method == null) {
      _logger.i("QPOSMODEL $qposModel method is null");
    } else {
      switch (method) {
        case 'onQposInfoResult':
          break;
        case 'onRequestTime':
          break;
        case 'onRequestDisplay':
          break;
        case 'onQposIdResult':
          if (parameters != null) {
            var listData = parameters.split(",");
            var result = listData[6].split("posId=")[1];
            _mydevice = _mydevice?.copyWith(id: result);
            _cache.saveQpos(_mydevice!);
            /*var d = mydevice!.toJson();
            d["id"] = result;
            var r = DeviceBluetooth.fromJson(d);
            mydevice = r;*/
            add(const BluetoothDeviceConnectedEvent());
          }
          break;
        case 'onDoTradeResult':
          break;
        case 'onRequestWaitingUser':
          break;
        case 'onRequestTransactionResult':
          break;
        case 'onReturnConverEncryptedBlockFormat':
          break;
        case 'onRequestQposDisconnected':
          _clearDevice();
          _logger.i("_manualDisconnection $_manualDisconnection");
          if (_manualDisconnection) {
            _manualDisconnection = false;
          } else {
            add(const StartBluetoothScanEvent());
          }
          break;
        case 'onGetInputAmountResult':
          break;
        case 'onRequestIsServerConnected':
          break;
        case 'onRequestFinalConfirm':
          break;
        case 'onSetBuzzerStatusResult':
          break;
        case 'onGetBuzzerStatusResult':
          break;
        case 'onReturnDownloadRsaPublicKey':
          break;
        case 'onReturnPowerOnIccResult':
          break;
        case 'onUpdateMasterKeyResult':
          break;
        case 'onBatchReadMifareCardResult':
          break;
        case 'onEmvICCExceptionData':
          break;
        case 'onBluetoothBondFailed':
          break;
        case 'onWriteBusinessCardResult':
          break;
        case 'onQposIsCardExist':
          break;
        case 'onRequestBatchData':
          break;
        case 'onReturniccCashBack':
          break;
        case 'onRequestSelectEmvApp':
          break;
        case 'onReturnUpdateIPEKResult':
          break;
        case 'onReturnUpdateEMVRIDResult':
          break;
        case 'onReturnUpdateEMVResult':
          break;
        case 'onSetBuzzerTimeResult':
          break;
        case 'onBluetoothBoardStateResult':
          break;
        case 'onReturnApduResult':
          break;
        case 'onLcdShowCustomDisplay':
          break;
        case 'onSetSleepModeTime':
          break;
        case 'onReturnGetEMVListResult':
          break;
        case 'onReturnGetPinResult':
          break;
        case 'onBluetoothBonded':
          break;
        case 'onReturnPowerOnNFCResult':
          break;
        case 'onRequestSetAmount':
          break;
        case 'onRequestQposConnected':
          _flutterPluginQpos.getQposId();
          break;
        case 'onUpdatePosFirmwareResult':
          break;
        case 'onPinKey_TDES_Result':
          break;
        case 'onReturnNFCApduResult':
          break;
        case 'onConfirmAmountResult':
          break;
        case 'onRequestDeviceScanFinished':
          _pendingDeviceScan = false;
          add(const BluetoothDeviceScanFinishedEvent());
          break;
        case 'onReturnBatchSendAPDUResult':
          break;
        case 'onSearchMifareCardResult':
          break;
        case 'onReturnReversalData':
          break;
        case 'onRequestCalculateMac':
          break;
        case 'onSetManagementKey':
          break;
        case 'onReturnPowerOffNFCResult':
          break;
        case 'onReturnPowerOffIccResult':
          break;
        case 'onBluetoothBondTimeout':
          break;
        case 'onRequestTransactionLog':
          break;
        case 'onGetCardNoResult':
          break;
        case 'onReturnCustomConfigResult':
          break;
        case 'onReturnSetMasterKeyResult':
          break;
        case 'onRequestUpdateWorkKeyResult':
          break;
        case 'onReturnSetSleepTimeResult':
          break;
        case 'onBluetoothBonding':
          break;
        case 'onRequestOnlineProcess':
          break;
        case 'onSetParamsResult':
          break;
        case 'onReadBusinessCardResult':
          break;
        case 'onRequestNoQposDetected':
          _disconnectDevice();
          add(const BluetoothDeviceScanErrorEvent("Dispositivo no es un QPOS"));
          break;
        case 'onBatchWriteMifareCardResult':
          break;
        case 'onSetBuzzerResult':
          break;
        case 'onRequestSignatureResult':
          break;
        case 'onRequestUpdateKey':
          break;
        case 'onReadMifareCardResult':
          break;
        case 'onWriteMifareCardResult':
          break;
        case 'onFinishMifareCardResult':
          break;
        case 'onOperateMifareCardResult':
          break;
        case 'onVerifyMifareCardResult':
          break;
        case 'onReturnAESTransmissonKeyResult':
          break;
        case 'onGetKeyCheckValue':
          break;
        case 'onReturnSignature':
          break;
        case 'getMifareFastReadData':
          break;
        case 'onReturnSetAESResult':
          break;
        case 'onReturnGetQuickEmvResult':
          break;
        case 'onQposDoGetTradeLogNum':
          break;
        case 'onQposIsCardExistInOnlineProcess':
          break;
        case 'getMifareCardVersion':
          break;
        case 'getMifareReadData':
          break;
        case 'onSetPosBlePinCode':
          break;
        case 'onQposDoGetTradeLog':
          break;
        case 'onGetDevicePubKey':
          break;
        case 'onRequestSetPin':
          break;
        case 'onCbcMacResult':
          break;
        case 'onAddKey':
          break;
        case 'onError':
          final error = parameters != null ? translate(parameters) : "Error";
          if (error == "DEVICE_RESET" || error == "DEVICE_BUSY") {
            _disconnect();
          }

          add(BluetoothDeviceScanErrorEvent(error));
          break;
        case 'onQposKsnResult':
          break;
        case 'onEncryptData':
          break;
        case 'onRequestDevice':
          break;
        case 'onTradeCancelled':
          break;
        case 'onQposDoTradeLog':
          break;
        case 'onWaitingforData':
          break;
        case 'onDeviceFound':
          var name = paras[0];
          var macAddress = paras[1];
          var number = paras[2];
          var device = DeviceBluetooth(name: name, macAddress: macAddress);
          _devices.add(device);
          add(const BluetoothDeviceOnDeviceFoundEvent());
          break;
        case 'onGetPosComm':
          break;
        case 'onQposDoSetRsaPublicKey':
          break;
        case 'verifyMifareULData':
          break;
        case 'onQposGenerateSessionKeysResult':
          break;
        case 'onRequestNoQposDetectedUnbond':
          break;
        case 'onReturnRSAResult':
          break;
        case 'writeMifareULData':
          break;
        case 'transferMifareData':
          break;
        case 'onGetShutDownTime':
          break;
        case 'onGetSleepModeTime':
          break;
      }
    }
  }

  void _clearDevice() {
    _mydevice = null;
    _cache.deleteQposData();
  }

  void _disconnectDevice() async {
    try {
      _clearDevice();
      await _flutterPluginQpos.disconnectBT();
    } catch (err) {
      _logger.e("DISCONNECT_TO_DEVICE", err);
    }
  }

  void _disconnect() {
    _manualDisconnection = true;
    _disconnectDevice();
  }

  @override
  Future<void> close() {
    _logger.i("CLOSE");
    _subscription?.cancel();
    return super.close();
  }
}

enum CommunicationMode {
  AUDIO,
  BLUETOOTH_VER2,
  UART,
  UART_K7,
  BLUETOOTH_2Mode,
  USB,
  BLUETOOTH_4Mode,
  UART_GOOD,
  USB_OTG,
  USB_OTG_CDC_ACM,
  BLUETOOTH,
  BLUETOOTH_BLE,
  //UNKNOW,
}
