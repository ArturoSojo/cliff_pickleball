import 'dart:async';

import 'package:flutter_plugin_qpos/QPOSModel.dart';
import 'package:flutter_plugin_qpos/flutter_plugin_qpos.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:cliff_pickleball/util/date_util.dart';

import '../../../utils/tlv_comparator.dart';
import '../../../widgets/Utils.dart';
import 'payment_qpos_listener.dart';

class PaymentQposService {
  StreamSubscription<QPOSModel>? _subscription;
  final _flutterPluginQpos = FlutterPluginQpos();
  final _logger = Logger();

  final PaymentQposListener _listener;
  final _tlvComparator = TlvComparator();

  PaymentQposService(this._listener);

  void init() async {
    cancel();
    _subscription =
        _flutterPluginQpos.onPosListenerCalled!.listen(_solveQPOSModel);
  }

  void cancel() {
    _subscription?.cancel();
  }

  void startDoTrade() async {
    int keyIndex = 0;

    _flutterPluginQpos.setFormatId(FormatID.DUKPT);

    await _flutterPluginQpos.doTrade(keyIndex);
  }

  void setPin(String pin) async {
    _flutterPluginQpos.sendPin(pin);
  }

  void _solveQPOSModel(QPOSModel qposModel) async {
    try {
      _handle(qposModel);
    } catch (e, s) {
      _logger.e("${qposModel.method} ERROR", e, s);
      _listener.error("FAILURE");
    }
  }

  void _handle(QPOSModel qposModel) async {
    var method = qposModel.method;
    List<String> paras = List.empty();
    String? parameters = qposModel.parameters;
    if (parameters != null && parameters.isNotEmpty) {
      paras = parameters.split("//");
    }
    _logger.i("QPOSMODEL $qposModel method $method parameters $parameters");
    if (method == null) {
      _logger.i("QPOSMODEL $qposModel method is null");
    } else {
      switch (method) {
        case 'onRequestWaitingUser':
          //case 'onDoTradeResult':
          _listener.enterCard();
          break;
        case 'onRequestQposDisconnected':
          _listener.deviceDisconnected();
          break;
        case "onMethodCalldisconnectBT":
          _listener.deviceDisconnected();
          break;
        case "onRequestSetAmount":
          Map<String, String> params = <String, String>{};
          params['transactionType'] = "SERVICES";
          params['currencyCode'] = '928';
          params['amount'] = _listener.getAmount();
          params['cashbackAmount'] = '';

          _flutterPluginQpos.setAmountIcon(
              AmountType.MONEY_TYPE_CUSTOM_STR, "Bs.");

          _flutterPluginQpos.setAmount(params);
          break;
        case 'onRequestDisplay':
          if (parameters != null) {
            _listener.display(parameters);
          }
          break;
        case "onRequestOnlineProcess":
          if (parameters != null) {
            var data = await _flutterPluginQpos.anlysEmvIccData(parameters);
            String tlv = data["tlv"];
            _listener.chipFound(tlv);
            _findAid(tlv);
            String str = "8A023030";
            _flutterPluginQpos.sendOnlineProcessResult(str);
          }
          break;
        case "onRequestBatchData":
          if (parameters != null) {
            var data = await _flutterPluginQpos.anlysEmvIccData(parameters);
            String tlv = data["tlv"];
            // _listener.chipFound(tlv);
            _findAid(tlv);
          } else {
            _listener.error("BATCH_DATA_IS_NULL");
          }
          break;
        case "onError":
          _listener.error(parameters);
          break;
        case "onRequestSetPin":
          _listener.requestPin();
          break;
        case 'onRequestTransactionResult':
          if (parameters == "DECLINED") {
            _listener.error('TARJETA DENEGADA, TIPO DE TARJETA INVÁLIDA');
          }
          /* if (parameters == "CANCEL" || parameters == "TERMINATED") {
            _listener.error(parameters!);
          }*/

          if (parameters == "APPROVED") {
            _listener.cardApproved();
          } else {
            _listener.error(parameters!);
          }
          break;
        case 'onRequestTime':
          _flutterPluginQpos.sendTime(DateUtil.qposDate());
          break;
        case 'onDoTradeResult':
          var trade = paras[0];
          if (Utils.equals(trade, "ICC")) {
            _flutterPluginQpos.doEmvApp("START");
            _listener.enterCard();
          }

          if (Utils.equals(trade, "NFC_ONLINE") ||
              Utils.equals(trade, "NFC_OFFLINE")) {
            var nfcBatchData = await _flutterPluginQpos.getNFCBatchData();
            String tlv = nfcBatchData["tlv"];
            _findAid(tlv);
            _logger.i("nfcBatchData $nfcBatchData");
            // _listener.cardApproved();
            //_listener.display(nfcBatchData);
          } else if (Utils.equals(trade, "MCR")) {
            _listener.error("INVALID_TRADE");
          } else {
            //_listener.error("INVALID_TRADE");
          }

          break;
        case 'onRequestSelectEmvApp':
          _flutterPluginQpos.selectEmvApp(1);
          break;
        case 'onReturnGetPinInputResult':
          var numPinField = int.parse(parameters!);
          _logger.i("numPinField $numPinField");
          break;
      }
    }
  }

  void _findAid(String tlv) {
    var aidInfo = _tlvComparator.aidInfo(tlv);

    if (aidInfo == null) {
      _logger.i("TLV $tlv");

      _listener.error("AID_NOT_FOUND");
      return;
    }

    _listener.aidFound(aidInfo);
  }

  void resetQPosStatus() {
    _flutterPluginQpos.resetQPosStatus();
  }
}
