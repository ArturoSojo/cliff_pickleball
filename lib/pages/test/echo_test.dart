import 'dart:async';
import 'dart:convert';

import "package:flutter/material.dart";
import 'package:flutter_plugin_qpos/QPOSModel.dart';
import 'package:flutter_plugin_qpos/flutter_plugin_qpos.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:optional/optional.dart';
import 'package:cliff_pickleball/di/injection.dart'; // import 'package:cliff_pickleball/di/injection.dart';
import 'package:cliff_pickleball/domain/device.dart';
import 'package:cliff_pickleball/pages/abstracts/base_page.dart';
import 'package:cliff_pickleball/pages/bluetooth/domain/device.dart';
import 'package:cliff_pickleball/pages/test/model/testModel.dart';
import 'package:cliff_pickleball/services/cacheService.dart';
import 'package:cliff_pickleball/services/http/api_services.dart';
import 'package:cliff_pickleball/services/http/result.dart';
import 'package:cliff_pickleball/styles/text.dart';
import 'package:cliff_pickleball/utils/receipData.dart';

import '../../domain/merchant_affiliation.dart';
import '../../styles/bg.dart';
import '../../styles/decorations_style.dart';
import '../../utils/translate.dart';
import '../../widgets/isNotBluetoothConnected.dart';

class EchoTestScreen extends BasePage {
  EchoTestScreen({Key? key}) : super(key: key);

  @override
  State<EchoTestScreen> createState() => _EchoTestState();
}

class _EchoTestState extends BaseState<EchoTestScreen> with BasicPage {
  final FlutterPluginQpos _flutterPluginQpos = FlutterPluginQpos();
  StreamSubscription? _subscription;
  final _apiServices = getIt<ApiServices>();
  QPOSModel? trasactionData;
  Device? _device = null;
  final _logger = Logger();
  DeviceBluetooth? _qpos = null;
  final _cache = Cache();
  final Map<String, dynamic> merchant = {};
  List Test = [];
  String qposid = "";

  @override
  void initState() {
    // _bloc().add(DeviceAndBluetoothInitialEvent());
    super.initState();
    getCache();
    _subscription =
        _flutterPluginQpos.onPosListenerCalled!.listen((QPOSModel datas) {
      parasListener(datas);
    });
    getMerchant();
  }

  @override
  void dispose() {
    super.dispose();
    if (_subscription != null) {
      _subscription!.cancel();
    }
  }

  Future<void> getCache() async {
    var device2 = await _cache.getDeviceInformation();
    var qpos = await _cache.getQpos();
    // _logger.i("esta es la data de device ${device2!.device!.toJson() ?? ""}");

    if (device2 != null && qpos != null) {
      setState(() {
        _device = device2.device;
        _qpos = qpos;
        qposid = _qpos?.id ?? "";
      });
    }
  }

  Future<void> disconnectToDevice() async {
    try {
      await _flutterPluginQpos.disconnectBT();
    } catch (err) {}
  }

  void parasListener(QPOSModel datas) {
    String? method = datas.method;
    List<String> paras = List.empty();
    String? parameters = datas.parameters;
    if (parameters != null && parameters.isNotEmpty) {
      paras = parameters.split("||");
    }
    switch (method) {
      case 'onRequestTime':
        _flutterPluginQpos.sendTime("20200215175558");
        break;
      case 'onRequestQposDisconnected':
        setState(() {
          try {
            disconnectToDevice();
            Cache().deleteQposData();
            context.pop();
          } catch (err) {
            // print(err);
          }
        });
        break;
      case 'onMethodCalldisconnectBT':
        setState(() {
          try {
            disconnectToDevice();
            Cache().deleteQposData();
            context.pop();
          } catch (err) {
            // print(err);
          }
        });
        break;
    }
  }

  void getMerchant() async {
    var results = await _cache.getCacheData('merchant');
    var results2 = await _cache.getCacheData('qposid');
    setState(() {
      if (results != null) {
        results = ReceiptData.getInformationDevice(json.decode(results!));
        var m = results;
        merchant.addAll(jsonDecode(m!) as Map<String, dynamic>);
      } else {}
    });
  }

  void clear() {
    setState(() {});
  }

  Future<Result<String>> _getTest() async {
    return await _apiServices
        .echoTest()
        .onError((error, stackTrace) => Result.fail(error, stackTrace));
  }

  Widget _showTest({List<TestModel?> list = const []}) {
    // _logger.i(list[0].channel);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Card(
        elevation: 2,
        color: MyTheme.grayLight,
        child: Column(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Image(
                                image: AssetImage("assets/img/pos.png"),
                                height: 100,
                                width: 100),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _device!.commerceName != null
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                child: RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                      text: "Comercio: ",
                                      style: titleStyleText("", 16)),
                                  TextSpan(
                                      text: "${_device!.commerceName ?? ""}",
                                      style: subtitleStyleText("", 16)),
                                  _device!.commerceEmail != null
                                      ? TextSpan(
                                          text:
                                              " (${_device!.commerceEmail ?? ""})",
                                          style: titleStyleText("", 16))
                                      : TextSpan()
                                ])))
                            : const SizedBox(),
                        const SizedBox(height: 5),
                        _device!.commerceIdDoc != null
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                child: RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                      text: "RIF: ",
                                      style: titleStyleText("", 16)),
                                  TextSpan(
                                      text: _device!.commerceIdDoc ?? "",
                                      style: subtitleStyleText("", 16)),
                                ])))
                            : const SizedBox(),
                        qposid != null
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                child: RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                      text: "Serial del dispositivo: ",
                                      style: titleStyleText("", 16)),
                                  TextSpan(
                                      text: qposid,
                                      style: subtitleStyleText("", 16))
                                ])))
                            : const SizedBox(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _device!.merchantAffiliations![0]
                                            .affiliationNumber !=
                                        null
                                    ? RichText(
                                        text: TextSpan(children: [
                                        TextSpan(
                                            text: "Nro. afiliación: ",
                                            style: titleStyleText("", 16)),
                                        TextSpan(
                                            text: _device!
                                                    .merchantAffiliations![0]
                                                    .affiliationNumber ??
                                                "",
                                            style: subtitleStyleText("", 16))
                                      ]))
                                    : const SizedBox(),
                                const SizedBox(height: 10),
                                _device!.merchantAffiliations![0].terminals![
                                            TransactionType.CREDIT]! !=
                                        null
                                    ? RichText(
                                        text: TextSpan(children: [
                                        TextSpan(
                                            text: "Terminal crédito: ",
                                            style: titleStyleText("", 16)),
                                        TextSpan(
                                            text: _device!
                                                        .merchantAffiliations![0]
                                                        .terminals![
                                                    TransactionType.CREDIT] ??
                                                "",
                                            style: subtitleStyleText("", 16))
                                      ]))
                                    : const SizedBox(),
                              ]),
                        ),
                      ]),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: ListView.separated(
                          itemCount: list.length,
                          separatorBuilder: (context, i) => const Divider(),
                          itemBuilder: (context, index) {
                            bool success = list[index]?.success ?? false;
                            return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        success
                                            ? SizedBox(
                                                width: (MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    200),
                                                child: RichText(
                                                    text: TextSpan(children: [
                                                  TextSpan(
                                                      text: "Mensaje: ",
                                                      style: titleStyleText(
                                                          "", 16)),
                                                  TextSpan(
                                                      text: "Exitoso",
                                                      style: subtitleStyleText(
                                                          "", 16))
                                                ])),
                                              )
                                            : SizedBox(
                                                width: (MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    200),
                                                child: RichText(
                                                    text: TextSpan(children: [
                                                  TextSpan(
                                                      text: "Mensaje: ",
                                                      style: titleStyleText(
                                                          "", 16)),
                                                  TextSpan(
                                                      text: list[index]
                                                              ?.message! ??
                                                          "",
                                                      style: subtitleStyleText(
                                                          "", 16))
                                                ])),
                                              ),
                                        SizedBox(
                                          width: (MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              200),
                                          child: RichText(
                                              text: TextSpan(children: [
                                            TextSpan(
                                                text: "Cod: ",
                                                style: titleStyleText("", 16)),
                                            TextSpan(
                                                text: list[index]
                                                        ?.responceCode! ??
                                                    "",
                                                style:
                                                    subtitleStyleText("", 16))
                                          ])),
                                        )
                                      ]),
                                  const SizedBox(),
                                  success
                                      ? Center(
                                          child: Lottie.asset(
                                              repeat: false,
                                              "assets/img/success.json",
                                              width: 50,
                                              height: 50))
                                      : Center(
                                          child: Lottie.asset(
                                              repeat: false,
                                              "assets/img/transaction-failed.json",
                                              width: 50,
                                              height: 50))
                                ]);
                          }),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Center(
                  child: IconButton(
                      onPressed: () => setState(() {}),
                      icon: const Icon(Icons.refresh, size: 40))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showErrorMessage(
      {String? errorMessage = "ERROR AL REALIZAR EL TEST"}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
            child: Lottie.asset("assets/img/transaction-failed.json",
                repeat: false, width: 100, height: 100)),
        const SizedBox(
          height: 10,
        ),
        Center(child: Text(errorMessage!, style: subtitleStyleText("gray", 16)))
      ],
    );
  }

  futureBuilder() {
    return FutureBuilder(
        future: _getTest(),
        builder:
            (BuildContext context, AsyncSnapshot<Result<String>> snapshot) {
          if (snapshot.data?.success == false) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: Lottie.asset("assets/img/transaction-failed.json",
                          repeat: false, width: 250, height: 140)),
                  Center(
                    child: Text(
                      translate(
                          (snapshot.data?.error ?? snapshot.data?.errorMessage)
                              .toString()),
                      style: titleStyleText("", 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }
          if (snapshot.hasError) {
            return _showErrorMessage(
                errorMessage: snapshot.stackTrace.toString());
          }
          if (snapshot.connectionState == ConnectionState.done) {
            var result = snapshot.data;
            if (result == null) {
              return _showErrorMessage(errorMessage: "Respuesta Vacia");
            }

            if (result.success) {
              var json = result.obj;
              if (json != null) {
                List _list = jsonDecode(json) ?? [];
                return dataTable(tests: _list);
              } else {
                return _showErrorMessage(errorMessage: "Respuesta Vacia 2");
              }
            }

            var errorMessage =
                result.errorMessage ?? "Error al realizar test de comunicación";

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _showErrorMessage(errorMessage: errorMessage),
              ],
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                    child: SizedBox(
                        width: 70,
                        height: 70,
                        child: CircularProgressIndicator(
                          color: ColorUtil.primaryColor(),
                          strokeWidth: 6,
                        ))),
                const SizedBox(
                  height: 10,
                ),
                Center(
                    child: Text(
                  'Realizando test de comunicación',
                  style: titleStyleText("", 20),
                )),
              ],
            );
          }
        });
  }

  List<TestModel?>? _checkoutTest(List tests) {
    if (tests.isNotEmpty) {
      var type = _device?.merchantAffiliations?[0]
          .bankTransactionalPaymentChannel?[PaymentCardType.TDD];
      if (type != null) {
        var channel = TestModel().reloadformattedChannel(type);
        _logger.i(channel);
        Map<String, dynamic>? testModel = tests
            .where((element) => element?["channel"] == channel)
            .firstOptional
            .orElseNull;

        if (testModel != null) {
          return [TestModel.fromJson(testModel)];
        }
      }
    }
    return null;
  }

  Widget dataTable({List? tests = const []}) {
    if (tests == null) {
      return _showErrorMessage();
    }
    if (tests.isEmpty) {
      return _showErrorMessage();
    }
    var result = _checkoutTest(tests) ?? [];
    if (result.isNotEmpty) {
      return _showTest(list: result);
    }
    return _showErrorMessage();
  }

  @override
  Widget rootWidget(BuildContext context) {
    if (_device == null && _qpos == null) {
      return const IsNotBluetoothConnected(
        message: "No hay información del dispositivo",
      );
    }
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Center(
              child: Text(
            "TEST",
            style: titleStyleText("white", 18),
          )),
          leading: IconButton(
              onPressed: (() => Navigator.pop(context)),
              icon: const Icon(Icons.arrow_back_sharp)),
        ),
        body: Center(child: futureBuilder()));
  }
}
