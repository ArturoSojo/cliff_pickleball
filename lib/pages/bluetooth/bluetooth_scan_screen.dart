import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_plugin_qpos/flutter_plugin_qpos.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:cliff_pickleball/pages/abstracts/base_page.dart';
import 'package:cliff_pickleball/pages/bluetooth/domain/device.dart';

import '../../styles/bg.dart';
import '../../styles/text.dart';
import '../../util/platform_util.dart';
import 'bluetooth_scan_bloc.dart';
import 'bluetooth_selector_mode.dart';
import 'device_list.dart';

class BluetoothScanScreen extends BasePage {
  BluetoothScanScreen({Key? key}) : super(key: key);

  @override
  State<BluetoothScanScreen> createState() => _BluetoothScanScreenState();
}

class _BluetoothScanScreenState extends BaseState<BluetoothScanScreen>
    with BasicPage, WidgetsBindingObserver {
  AppLifecycleState? _lastLifecycleState;
  final _logger = Logger();
  final _flutterPluginQpos = FlutterPluginQpos();

  BluetoothScanBloc _bloc() {
    return context.read<BluetoothScanBloc>();
  }

  @override
  void initState() {
    _bloc().add(const BluetoothScanInitEvent());
    _flutterPluginQpos.resetQPosStatus();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _logger.i("$state");
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        if (_lastLifecycleState != null) {
          _disconnectDevice();
        }
        break;
    }
    _lastLifecycleState = state;
  }

  @override
  Widget rootWidget(BuildContext context) {
    return BlocConsumer<BluetoothScanBloc, BluetoothScanState>(
      bloc: _bloc(),
      listener: (context, state) {
        //_logger.i("STATE_LISTENER ${state.runtimeType}");
      },
      builder: (context, state) {
        _logger.i("STATE_BUILDER ${state.runtimeType}");

        /* if (state is BluetoothScanInitial) {
          _bloc().add(const BluetoothScanInitEvent());
        } */

        var isLoading =
            state is BluetoothDeviceScanningState && !state.scanFinished;

        var deviceCount =
            (state is BluetoothDeviceScanningState) ? state.devices.length : 0;

        if (state is StartBluetoothSelectCommunicationModeState) {
          return SelectBleMode(state.mode, _bloc());
        }

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Center(
              child: Text(
                "BLUETOOTH",
                style: titleStyleText("white", 18),
              ),
            ),
          ),
          body: Column(
            children: [
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Nombre del dispositivo",
                                  style: titleStyleText("", 16)),
                              FutureBuilder(
                                future: PlatformUtil.getDeviceName(),
                                builder: (context, snapshot) {
                                  return Text(snapshot.data ?? "",
                                      style: titleStyleText("", 16));
                                },
                              ),
                            ]),
                        const SizedBox(
                          height: 10,
                        ),
                        state is BluetoothDeviceConnectingState
                            ? const SizedBox(height: 25)
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                    Text(
                                        "Dispositivos disponibles $deviceCount",
                                        style: subtitleStyleText("", 20)),
                                    InkWell(
                                        onTap: () => _selectCommunicationMode(),
                                        child: const Icon(
                                          Icons.settings,
                                          size: 30,
                                        )),
                                    InkWell(
                                        onTap: () =>
                                            isLoading ? null : _scanDevices(),
                                        child: isLoading
                                            ? const SizedBox(
                                                height: 25,
                                                width: 25,
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : const Icon(
                                                Icons.refresh,
                                                size: 30,
                                              ))
                                  ]),
                        const Divider(),
                      ])),
              Expanded(
                  child: Container(
                padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                child: body(state),
              ))
            ],
          ),
        );
      },
    );
  }

  Widget _showErrorMessage(DeviceBluetooth? device, String errorMessage) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Lottie.asset(
                  repeat: false,
                  "assets/img/transaction-failed.json",
                  width: 250,
                  height: 140)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      errorMessage,
                      style: titleStyleText("", 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          device == null ? const SizedBox() : _deviceWidget(device),
          device == null || device.id == null
              ? const SizedBox()
              : _disconnectBtn()
        ]);
  }

  Widget body(BluetoothScanState state) {
    if (state is ErrorState) {
      /* EL PROGRAMA ESTÁ RECIBIENDO EL ERROR TRADUCIDO */
      if (state.error == "ERROR DISPOSITIVO OCUPADO EN OTRA TRANSACCIÓN") {
        return Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Center(
              child: Column(children: const [
            CircularProgressIndicator(
              strokeWidth: 5,
            ),
          ])),
        );
      } else {
        return _showErrorMessage(state.device, "Error: ${state.error}");
      }
    }

    if (state is BluetoothDeviceConnectingState) {
      var device = state.device;
      return Center(
          child: Column(children: [
        const CircularProgressIndicator(
          strokeWidth: 5,
        ),
        const SizedBox(height: 20),
        Text(device.id == null ? "Conectando..." : "Buscando Dispositivo"),
        const SizedBox(height: 20),
        _deviceWidget(device),
        device.id == null ? const SizedBox() : _disconnectBtn()
      ]));
    }

    if (state is BluetoothDeviceConnectedState) {
      var result = state.result;

      if (result != null) {
        if (result.success) {
          var json = result.obj;
          if (json != null) {
            Map<String, dynamic> data = jsonDecode(json);

            if (data.containsKey("device")) {
              return _deviceConnected(state.device);
            }

            _bloc().add(const BluetoothDeviceDisconnectEvent());
            return _showErrorMessage(state.device, "Dispositivo no encontrado");
          } else {
            _bloc().add(const BluetoothDeviceDisconnectEvent());
            return _showErrorMessage(state.device, "Respuesta Vacia");
          }
        }

        _bloc().add(const BluetoothDeviceDisconnectEvent());

        var errorMessage =
            result.errorMessage ?? "Error al consultar el dispositivo";
        return _showErrorMessage(state.device, errorMessage);
      }

      return Center(
          child: Column(children: [
        const SizedBox(height: 20),
        const Text("Dispositivo Conectado"),
        const SizedBox(height: 20),
        _deviceWidget(state.device),
        _disconnectBtn()
      ]));
    }

    return DeviceList(bloc: _bloc());
  }

  Widget _disconnectBtn() {
    return ElevatedButton(
      style: TextButton.styleFrom(padding: const EdgeInsets.all(20)),
      onPressed: _disconnectDevice,
      child: Text(
        "Desconectar",
        style: subtitleStyleText("white", 18),
      ),
    );
  }

  void _disconnectDevice() {
    _bloc().add(const BluetoothDeviceDisconnectEvent());
    _scanDevices();
  }

  Widget _deviceWidget(DeviceBluetooth device) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.symmetric(vertical: 8),
      alignment: Alignment.center,
      child: Center(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            const Icon(
              Icons.bluetooth,
              size: 25,
            ),
            const SizedBox(width: 15),
            Column(children: [
              device.name != "null"
                  ? Text(device.name, style: titleStyleText("", 16))
                  : const SizedBox(height: 4),
              Text(device.macAddress, style: titleStyleText("", 16)),
              Text(device.id ?? "", style: titleStyleText("", 16))
            ]),
          ])),
    );
  }

  void _scanDevices() {
    _bloc().add(const StartBluetoothScanEvent());
  }

  void _selectCommunicationMode() {
    _bloc().add(const StartBluetoothSelectCommunicationModeEvent());
  }

  Widget _deviceConnected(DeviceBluetooth device) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 350,
          height: 370,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Card(
              color: ColorUtil.grayLight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Image(
                      image: AssetImage("assets/img/pos.png"),
                      height: 80,
                      width: 80),
                  const SizedBox(height: 20),
                  Text("Dispositivo conectado a:",
                      style: subtitleStyleText("", 18)),
                  _deviceWidget(device),
                  Container(
                    margin: const EdgeInsets.fromLTRB(4, 15, 4, 20),
                    child: _disconnectBtn(),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
