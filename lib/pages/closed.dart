import 'dart:async';
import 'dart:convert';

import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_plugin_qpos/QPOSModel.dart';
import 'package:flutter_plugin_qpos/flutter_plugin_qpos.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:cliff_pickleball/pages/abstracts/base_page.dart';
import 'package:cliff_pickleball/services/cacheService.dart';
import 'package:cliff_pickleball/services/http/api_services.dart';
import 'package:cliff_pickleball/services/http/result.dart';
import 'package:cliff_pickleball/styles/bg.dart';
import 'package:cliff_pickleball/styles/text.dart';
import 'package:cliff_pickleball/utils/receipData.dart';
import 'package:cliff_pickleball/widgets/closed_receipt.dart';

import '../blocs/device_and_bluetooth/device_and_bluetooth_bloc.dart';
import '../di/injection.dart';
import '../utils/showErrorMessage.dart';
import '../utils/translate.dart';
import '../widgets/isNotBluetoothConnected.dart';

class Closed extends BasePage {
  Closed({Key? key}) : super(key: key);

  @override
  State<Closed> createState() => _ClosedState();
}

class _ClosedState extends BaseState<Closed> with BasicPage {
  final FlutterPluginQpos _flutterPluginQpos = FlutterPluginQpos();
  final _apiServices = getIt<ApiServices>();
  StreamSubscription? _subscription;
  QPOSModel? trasactionData;
  final cache = Cache();
  final Map<String, dynamic> merchant = {};
  Map<String, String> params = {};
  String qposid = "";
  String device = "";
  List closed = [];

  Future<Result<String>> empty() async {
    return Future.value();
  }

  DeviceAndBluetoothBloc _bloc() {
    return context.read<DeviceAndBluetoothBloc>();
  }

  late Future _value;
  late Future<Result<String>> _value2;
  Map<String, dynamic> body = {};
  bool statusCierre = false;

  @override
  void initState() {
    _bloc().add(DeviceAndBluetoothInitialEvent());
    super.initState();
    _subscription =
        _flutterPluginQpos.onPosListenerCalled!.listen((QPOSModel datas) {
      parasListener(datas);
    });
    _value = empty();
    _value2 = empty();
    getMerchant();
  }

  @override
  void dispose() {
    super.dispose();
    if (_subscription != null) {
      _subscription!.cancel();
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
    if (parameters != null && parameters.length > 0) {
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
    var qpos = await cache.getQpos();
    setState(() {
      qposid = qpos?.id ?? "";
      _value = getLote();
    });
  }

  void clear() {
    setState(() {
      // _value2 = getClosed();
    });
  }

  String formattedChannel(String channel) {
    if (channel == "CHANNEL_7_7") {
      return "MC77";
    }
    if (channel == "CHANNEL_7_3") {
      return "MC73";
    }
    return channel;
  }

  formatted_terminals(p) {
    List<Map<String, dynamic>> d = [];
    if (p.containsKey("bank_transactional_payment_channel")) {
      if (p.containsKey("terminals")) {
        if (p["terminals"].containsKey("CREDIT")) {
          var result = {
            "channel": formattedChannel(
                p["bank_transactional_payment_channel"]["TDC"]),
            "terminal": p["terminals"]["CREDIT"],
            "type": "CREDITO"
          };
          d.add(result);
        }
        if (p["terminals"].containsKey("DEBIT")) {
          var result = {
            "channel": formattedChannel(
                p["bank_transactional_payment_channel"]["TDD"]),
            "terminal": p["terminals"]["DEBIT"],
            "type": "DEBITO"
          };
          d.add(result);
        }
      }
    }
    return d;
  }

  Future<Result<String>> getClosed() async {
    var deviceInformation = await cache.getDeviceInformation();
    Map<String, String> params = {};
    params["device_identifier"] = qposid;
    params["email_owner"] = deviceInformation!.device!.commerceEmail ?? "";

    return await getIt<ApiServices>()
        .closed(params, body)
        .onError((error, stackTrace) => Result.fail(error, stackTrace));
  }

  Future<Result<String>> getLote() async {
    var response = await _apiServices
        .openLote(body)
        .onError((error, stackTrace) => Result.fail(error, stackTrace));
    return response;
  }

  void setBody(List<dynamic> data) {
    print(data[0]);
    setState(() {});
  }

  futureLote() {
    return FutureBuilder(
        future: getLote(),
        builder:
            (BuildContext context, AsyncSnapshot<Result<String>> snapshot) {
          print("este es el stacktrace ${(snapshot.error).toString()}");
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
            return showErrorMessage(snapshot.stackTrace.toString());
          }
          if (snapshot.connectionState == ConnectionState.done) {
            var result = snapshot.data;
            if (result == null) {
              return showErrorMessage("Respuesta Vacia");
            }
            if (result.success) {
              var json = result.obj;
              if (json != null) {
                var resultOpenLote = jsonDecode(json);
                return dataTable(resultOpenLote);
              } else {
                return showErrorMessage("Respuesta Vacia");
              }
            }
            var errorMessage =
                result.errorMessage ?? "Error al consultar el dispositivo";
            return showErrorMessage(errorMessage);
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
                  'Verificando lotes abiertos',
                  style: titleStyleText("", 20),
                )),
              ],
            );
          }
        });
  }

  Widget _showError(String errorMessage) {
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
            child: Center(
                child: Text(
              errorMessage,
              style: titleStyleText("", 20),
            )),
          )
        ]);
  }

  futureBuilder() {
    return FutureBuilder(
        future: _value2,
        builder:
            (BuildContext context, AsyncSnapshot<Result<String>> snapshot) {
          if (snapshot.data?.success == false) {
            print("este es el ${snapshot.data?.error}");
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: Lottie.asset(
                          repeat: false,
                          "assets/img/transaction-failed.json",
                          width: 250,
                          height: 140)),
                  Center(
                    child: Text(
                      (snapshot.data?.error ?? snapshot.data?.errorMessage)
                                  .toString()
                                  .toUpperCase() ==
                              "SOFTWARE CAUSED CONNECTION ABORT"
                          ? "CONEXIÓN DE INTERNET INTERRUMPIDA, POR FAVOR REVISE SU CORREO ELECTRÓNICO O LA SECCIÓN DE LOTES EN EL ADMINISTRADOR"
                          : translate((snapshot.data?.error ??
                                  snapshot.data?.errorMessage)
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
            return _showError(snapshot.stackTrace.toString());
          }
          if (snapshot.connectionState == ConnectionState.done) {
            var result = snapshot.data;
            if (result == null) {
              return _showError("Respuesta Vacia");
            }
            if (result.success) {
              var json = result.obj;
              if (json != null) {
                List mydata = jsonDecode(json);
                if (mydata.length != 0) {
                  for (var i = 0; i < mydata.length; i++) {
                    if (mydata[i] != null) {
                      if (mydata[i].containsKey("card_type")) {
                        if (mydata[i].containsKey("success")) {
                          if (mydata[i]["status"] != "CLOSED" ||
                              mydata[i]["success"] != true) {
                            mydata[i]["message"] =
                                "No se puedo realizar el cierre, intente de nuevo";
                          } else {
                            mydata[i]["message"] = null;
                          }
                        }
                      }
                    }
                  }
                } else {
                  return Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                        Center(
                            child: Lottie.asset(
                                "assets/img/transaction-failed.json",
                                repeat: false,
                                width: 100,
                                height: 100)),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                            child: Text(
                          "Hubo un error al realizar el cierre del punto",
                          style: titleStyleText("", 18),
                          textAlign: TextAlign.center,
                        ))
                      ]));
                }
                print("data formateada ${ReceiptData.formattedClose(mydata)}");
                return ClosedReceipt(data: ReceiptData.formattedClose(mydata));
              } else {
                return _showError("Respuesta Vacia");
              }
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: Lottie.asset(
                            repeat: false,
                            "assets/img/transaction-failed.json",
                            width: 250,
                            height: 140)),
                    Center(
                      child: Text(
                        translate((snapshot.data?.error ??
                                snapshot.data?.errorMessage)
                            .toString()),
                        style: titleStyleText("", 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            }
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
                  'Realizando cierre',
                  style: titleStyleText("", 20),
                )),
              ],
            );
          }
        });
  }

  generateModal() {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: ColorUtil.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('¿Estas seguro que deseas cerrar la caja?',
                    style: subtitleStyleText("", 16)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.fromLTRB(4, 15, 1, 5),
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: ColorUtil.gray,
                                    padding: const EdgeInsets.all(20)),
                                child: Text("REGRESAR",
                                    selectionColor: ColorUtil.primaryColor(),
                                    style: subtitleStyleText("white", 15)),
                                onPressed: () => Navigator.pop(context)))),
                    Expanded(
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.fromLTRB(1, 15, 4, 5),
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: ColorUtil.error,
                                    padding: const EdgeInsets.all(20)),
                                child: Text("CERRAR CAJA",
                                    selectionColor: ColorUtil.primaryColor(),
                                    style: subtitleStyleText("white", 15)),
                                onPressed: () => setState(() {
                                      _value2 = getClosed();
                                      Navigator.pop(context);
                                      statusCierre = true;
                                    }))))
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget dataTable(data) {
    if (data.isEmpty) {
      return const Center(child: Text("NO HAY LOTES ABIERTOS"));
    }
    if (data.length == 0) {
      return const Center(child: Text("NO HAY LOTES ABIERTOS"));
    }
    return Center(
      child: Container(
        width: 300,
        height: 400,
        child: Card(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Center(
                      child: Column(
                    children: [
                      Text("CERRAR TERMINAL", style: subtitleStyleText("", 18)),
                      const SizedBox(height: 5),
                      Text(qposid, style: titleStyleText("", 18)),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.fromLTRB(1, 15, 4, 5),
                                child: TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor: ColorUtil.error,
                                        padding: const EdgeInsets.all(20)),
                                    child: Text("CERRAR CAJA",
                                        selectionColor:
                                            ColorUtil.primaryColor(),
                                        style: subtitleStyleText("white", 15)),
                                    onPressed: () => setState(() {
                                          qposid = data[0]["device"]
                                                  ["identifier"]
                                              .toString();
                                          device = data[0]["device"]
                                                  ["business_email"]
                                              .toString();
                                          body = ReceiptData.formattedOpenLote(
                                              data);
                                          generateModal();
                                        }))),
                          ),
                        ],
                      )
                    ],
                  )),
                ),
              ]),
        ),
      ),
    );
  }

  @override
  Widget rootWidget(BuildContext context) {
    return BlocConsumer<DeviceAndBluetoothBloc, DeviceAndBluetoothState>(
      bloc: _bloc(),
      listener: (context, state) async {
        if (state is DeviceAndBluetoothInitialEvent) {
          await _bloc().getBluetoothDevice();
        }
      },
      builder: (context, state) {
        if (!(state is BluetoothDeviceConnectedState)) {
          _bloc().getInitState();
          return const IsNotBluetoothConnected(
              message: "No hay dispositivo conectado");
        }
        if (state is BluetoothDisconnectState) {
          return const IsNotBluetoothConnected(
            message: "No hay dispositivo conectado",
          );
        }
        return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Center(
                  child: Text(
                "CERRAR TERMINAL",
                style: titleStyleText("white", 18),
              )),
              leading: IconButton(
                  onPressed: (() => Navigator.pop(context)),
                  icon: const Icon(Icons.arrow_back_sharp)),
            ),
            body: statusCierre == false ? futureLote() : futureBuilder());
      },
    );
  }
}
