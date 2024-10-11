import 'dart:async';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_qpos/QPOSModel.dart';
import 'package:flutter_plugin_qpos/flutter_plugin_qpos.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:cliff_pickleball/pages/abstracts/base_page.dart';
import 'package:cliff_pickleball/services/cacheService.dart';
import 'package:cliff_pickleball/util/date_util.dart';
import 'package:cliff_pickleball/utils/staticNamesRoutes.dart';
import 'package:cliff_pickleball/utils/translate.dart';
import 'package:cliff_pickleball/utils/utils.dart';

import '../di/injection.dart';
import '../styles/bg.dart';
import '../styles/color_provider/color_provider.dart';
import '../styles/text.dart';
import '../styles/theme_provider.dart';
import '../widgets/LogUtil.dart';
import '../widgets/Utils.dart';

class AnulatedCard extends BasePage {
  final Map<String, dynamic> data;

  AnulatedCard({super.key, required this.data});

  @override
  State<AnulatedCard> createState() => _AnulatedCardState();
}

class _AnulatedCardState extends BaseState<AnulatedCard> with BasicPage {
  final _logger = Logger();

  final FlutterPluginQpos _flutterPluginQpos = FlutterPluginQpos();
  StreamSubscription? _subscription;
  QPOSModel? trasactionData;
  final CurrencyTextInputFormatter _formatter =
      CurrencyTextInputFormatter(symbol: "Bs. ");

  Map<String, String> params = <String, String>{};
  String displayMessage = "";
  final bool status = false;
  String qposid = "";
  String tlvChip = "";
  Map<String, dynamic> typeCardObject = {};
  var approved = false;
  Map<String, dynamic> d = {};

  @override
  void initState() {
    super.initState();
    d = widget.data;
    getDeviceId();
    _subscription =
        _flutterPluginQpos.onPosListenerCalled!.listen((QPOSModel datas) {
      parasListener(datas);
    });
    startDoTrade();
  }

  void getDeviceId() async {
    var device_id = await Cache().getCacheData("qposid");
    setState(() {
      qposid = device_id!;
    });
  }

  void startDoTrade() async {
    int keyIndex = 0;
    _flutterPluginQpos.setFormatId(FormatID.DUKPT);
    await _flutterPluginQpos.doTrade(keyIndex);
  }

  Future<void> disconnectToDevice() async {
    try {
      await _flutterPluginQpos.disconnectBT();
    } catch (err) {}
  }

  void setAmount() {
    Map<String, String> params = <String, String>{};
    try {
      params['transactionType'] = "GOODS";
      params['currencyCode'] = '928';
      params['amount'] = double.parse(d["amount"]!).toStringAsFixed(0);
      params['cashbackAmount'] = "";
      _flutterPluginQpos.setAmountIcon(AmountType.MONEY_TYPE_CUSTOM_STR, "Bs.");
      _flutterPluginQpos.setAmount(params);
    } catch (err) {}
  }

  void setDataRequest(tlv) {
    setState(() {
      typeCardObject["id"] = d['id'];
      typeCardObject["amount"] = d['monto']!.split("Bs. ").join("");
      typeCardObject["account_type"] = d['account_type'];
      typeCardObject["emv"] = "SI";
      typeCardObject["status_id"] = "ANULATED";
      typeCardObject["mode_pan"] = "CHIP";
      typeCardObject["mode_pin"] = "PIN";
      typeCardObject["device_identifier"] = qposid;

      typeCardObject["operation_description"] = "PAY CHIP";
      typeCardObject["emv"] = "SI";
      typeCardObject["card_holder_id"] =
          MyUtils.parseDNI(d["card_holder_id"].toString());
      if (tlv != null) {
        typeCardObject["merchant"] = {"chip": tlvChip};
        typeCardObject["transaction_type"] = "CREDITO";
      } else {
        _logger.d(
            "estas en payment card y esta es la daata que se va a enviar$typeCardObject");

        typeCardObject["transaction_type"] = "DEBITO";
        context.goNamed(StaticNames.AnulateResultName.name,
            extra: typeCardObject);
      }
    });
  }

  void requestBatchData(parameters) async {
    try {
      var tlvData = parameters!;
      Future map = _flutterPluginQpos
          .anlysEmvIccData(parameters)
          .then((value) => setState(() {
                LogUtil.v("anlysEmvIccData: $value");
                var tlvData = value["tlv"];
                if (tlvData != "") {
                  setDataRequest(tlvData);
                }
              }));
    } catch (err) {
      _logger.e("requestBatchData", err);
    }
  }

  void onlineProcess(parameters) {
    try {
      var tlvData = parameters!;
      Future map = _flutterPluginQpos
          .anlysEmvIccData(parameters)
          .then((value) => setState(() {
                tlvChip = value["tlv"];
                String str = "8A023030";
                _flutterPluginQpos.sendOnlineProcessResult(str);
              }));
    } catch (err) {
      // print(err);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_subscription != null) {
      _subscription!.cancel();
    }
  }

  void parasListener(QPOSModel datas) {
    String? method = datas.method;
    List<String> paras = List.empty();
    String? parameters = datas.parameters;
    if (parameters != null && parameters.isNotEmpty) {
      paras = parameters.split("||");
    }
    switch (method) {
      case 'onDoTradeResult':
        try {
          // print("estos son los parametros ======> " + paras[0]);
          if (Utils.equals(paras[0], "ICC")) {
            _flutterPluginQpos.doEmvApp("START");
          }

          if (Utils.equals(paras[0], "NFC_ONLINE") ||
              Utils.equals(paras[0], "NFC_OFFLINE")) {
            Future map =
                _flutterPluginQpos.getNFCBatchData().then((value) => {});
          } else if (Utils.equals(paras[0], "MCR")) {
            // print("MCR -------->" + paras[1]);
          }
        } catch (err) {
          _logger.e("Error", err);
        }
        break;
      case 'onRequestWaitingUser':
        setState(() {
          displayMessage = "POR FAVOR INSERTE LA TARJETA";
        });
        break;
      case 'onRequestTime':
        _flutterPluginQpos.sendTime(DateUtil.qposDate());
        break;
      case 'onRequestQposConnected':
        break;
      case 'onRequestSetPin':
        setState(() {
          setDataRequest(null);
        });
        break;
      case 'onRequestSelectEmvApp':
        _flutterPluginQpos.selectEmvApp(0);
        break;
      case 'onRequestSetAmount':
        setState(() {
          try {
            setAmount();
          } catch (err) {
            _logger.e("Error", err);
          }
        });
        break;
      case 'onRequestTransactionResult':
        setState(() {
          try {
            if (parameters == "APPROVED") {
              context.goNamed(StaticNames.AnulateResultName.name,
                  extra: typeCardObject);
            }
          } catch (e) {
            _logger.e("Error", e);
          }
        });
        break;
      case 'onRequestQposDisconnected':
        setState(() {
          try {
            disconnectToDevice();
            Cache().deleteQposData();
            context.go(StaticNames.homeName.path);
          } catch (err) {
            // print(err);
          }
        });
        break;
      case 'onRequestOnlineProcess':
        try {
          onlineProcess(parameters);
        } catch (err) {
          // print(err);
        }
        break;
      case "onRequestDisplay":
        setState(() {
          try {
            displayMessage = translate(parameters!);
          } catch (e) {
            _logger.e("Error", e);
          }
        });
        break;

      case 'onRequestBatchData':
        requestBatchData(parameters!);
        break;
      case "onError":
        setState(() {
          if (parameters == "CMD_TIMEOUT") {
            context.go(StaticNames.homeName.path);
          }
          displayMessage = translate(parameters!);
        });
    }
  }

  @override
  Widget rootWidget(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
        body: GestureDetector(
      onHorizontalDragUpdate: (updateDetails) {},
      child: Container(
        color: ColorUtil.primaryColor(),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(height: 100),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_formatter.format(d["amount"]!),
                                style: titleStyleText("white", 40 * textScale)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                "${d["card_holder_id"].replaceAll(RegExp(r'^0+(?=.)'), '')}",
                                style:
                                    subtitleStyleText("white", 30 * textScale))
                          ],
                        ),
                      ])),
              LottieBuilder.asset("assets/img/insert-card-2.json"),
              Text(displayMessage.isEmpty ? "" : displayMessage,
                  style: subtitleStyleText("white", 14)),
              const SizedBox(height: 10)
            ]),
      ),
    ));
  }
}
