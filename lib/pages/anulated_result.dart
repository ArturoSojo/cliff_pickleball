import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:cliff_pickleball/di/injection.dart';
import 'package:cliff_pickleball/pages/abstracts/base_page.dart';
import 'package:cliff_pickleball/pages/anulated_receipt.dart';
import 'package:cliff_pickleball/services/http/api_services.dart';
import 'package:cliff_pickleball/styles/bg.dart';
import 'package:cliff_pickleball/styles/text.dart';
import 'package:cliff_pickleball/utils/staticNamesRoutes.dart';
import 'package:cliff_pickleball/utils/translate.dart';

import '../blocs/device_and_bluetooth/device_and_bluetooth_bloc.dart';
import '../services/cacheService.dart';
import '../services/http/result.dart';
import '../utils/receipData.dart';
import '../widgets/isNotBluetoothConnected.dart';

class AnulatedResult extends BasePage {
  final Map<String, dynamic> data;

  AnulatedResult({super.key, required this.data});

  @override
  State<StatefulWidget> createState() => _TransactionResultState();
}

class _TransactionResultState extends BaseState<AnulatedResult> with BasicPage {
  Map<String, dynamic> d = {};
  Map<String, dynamic> data = {};
  late Future<Result<String>> _value;
  final _cache = Cache();
  final _apiServices = getIt<ApiServices>();

  Future<Result<String>> sendPosData() async {
    var params = <String, String>{};
    params["id"] = d["id"]!;
    var body = d;
    var qpos = await _cache.getQpos();
    body["device_identifier"] = qpos!.id;
    return await _apiServices
        .anulatePayment(params, body)
        .onError((error, stackTrace) => Result.fail(error, stackTrace));
  }

  DeviceAndBluetoothBloc _bloc() {
    return context.read<DeviceAndBluetoothBloc>();
  }

  Future empty() async {}

  @override
  void dispose() {
    super.dispose();
    data = {};
  }

  @override
  void initState() {
    _bloc().add(DeviceAndBluetoothInitialEvent());
    super.initState();
    d = widget.data;
    _value = sendPosData();
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
                Text('¿Seguro que deseas anular la transacción nuevamente?',
                    style: subtitleStyleText("", 16),
                    textAlign: TextAlign.center),
                const SizedBox(
                  height: 7,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Container(
                            padding: const EdgeInsets.all(7),
                            margin: const EdgeInsets.fromLTRB(4, 15, 1, 5),
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: ColorUtil.gray,
                                    padding: const EdgeInsets.all(20)),
                                child: Text("REGRESAR",
                                    selectionColor: ColorUtil.primaryColor(),
                                    style: subtitleStyleText("white", 15)),
                                onPressed: () => context.pop()))),
                    Expanded(
                        child: Container(
                            padding: const EdgeInsets.all(7),
                            margin: const EdgeInsets.fromLTRB(1, 15, 4, 5),
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: ColorUtil.primaryColor(),
                                    padding: const EdgeInsets.all(20)),
                                child: Text("ACEPTAR",
                                    selectionColor: ColorUtil.primaryColor(),
                                    style: subtitleStyleText("white", 15)),
                                onPressed: () => setState(() {
                                      context.pop();
                                      _value = sendPosData();
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
        if (state is! BluetoothDeviceConnectedState) {
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
          body: FutureBuilder(
              future: _value,
              builder: (BuildContext context,
                  AsyncSnapshot<Result<String>> snapshot) {
                print(snapshot.data?.obj);
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
                if (snapshot.hasError) {
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
                      Center(
                        child: Text(snapshot.error.toString()),
                      )
                    ],
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
                    print("este es el json $json");
                    if (json != null) {
                      Map<String, dynamic> map = jsonDecode(json);
                      var receipt = ReceiptData.getReceipt(map);
                      return AnulatedReceipt(receipt);
                    } else {
                      return _showError("Respuesta Vacia 2");
                    }
                  }

                  var errorMessage =
                      result.errorMessage ?? "Error al realizar anulación";

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _showError(errorMessage),
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 7, horizontal: 20),
                                  margin:
                                      const EdgeInsets.fromLTRB(4, 15, 1, 5),
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor:
                                              ColorUtil.primaryColor(),
                                          padding: const EdgeInsets.all(20)),
                                      child: Text("INTENTAR NUEVAMENTE",
                                          selectionColor: ColorUtil.gray,
                                          style:
                                              subtitleStyleText("white", 15)),
                                      onPressed: () => setState(() {
                                            context
                                                .go(StaticNames.homeName.path);
                                          })))),
                        ],
                      ),
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
                        'Procesando anulación',
                        style: titleStyleText("", 20),
                      )),
                    ],
                  );
                }
              }),
        );
      },
    );
  }
}
