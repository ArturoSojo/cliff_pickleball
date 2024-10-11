import 'dart:async';
import 'dart:convert';

import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_plugin_qpos/QPOSModel.dart';
import 'package:flutter_plugin_qpos/flutter_plugin_qpos.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:cliff_pickleball/di/injection.dart';
import 'package:cliff_pickleball/pages/abstracts/base_page.dart';
import 'package:cliff_pickleball/services/cacheService.dart';
import 'package:cliff_pickleball/services/http/api_services.dart';
import 'package:cliff_pickleball/styles/bg.dart';
import 'package:cliff_pickleball/styles/text.dart';
import 'package:cliff_pickleball/utils/receipData.dart';
import 'package:cliff_pickleball/utils/staticNamesRoutes.dart';

import '../../blocs/device_and_bluetooth/device_and_bluetooth_bloc.dart';
import '../../services/http/result.dart';
import '../../styles/color_provider/color_provider.dart';
import '../../styles/theme_provider.dart';
import '../../utils/showErrorMessage.dart';
import '../../utils/translate.dart';
import '../../widgets/isNotBluetoothConnected.dart';
import 'model/last_model.dart';

class LastReport extends BasePage {
  LastReport({Key? key}) : super(key: key);

  @override
  State<LastReport> createState() => _LastReportState();
}

class _LastReportState extends BaseState<LastReport> with BasicPage {
  final FlutterPluginQpos _flutterPluginQpos = FlutterPluginQpos();

  DeviceAndBluetoothBloc _bloc() {
    return context.read<DeviceAndBluetoothBloc>();
  }

  StreamSubscription? _subscription;
  final cache = Cache();
  late TextEditingController type;
  late TextEditingController status;
  late bool stateFilter;
  late Map body;
  final Map<String, dynamic> merchant = {};
  DateTime dateTime = DateTime.now();

  final List<SelectedListItem> _listOfType = [
    SelectedListItem(
      name: "CREDITO",
      value: "CREDITO",
      isSelected: false,
    ),
    SelectedListItem(
      name: "DEBITO",
      value: "DEBITO",
      isSelected: false,
    ),
  ];
  late String device_id;
  late String today;

  final format = DateFormat(
    'DD/MM/Y',
  );
  final format2 = DateFormat(
    'y-MM-dd',
  );

  late String hoy;

  @override
  void initState() {
    _bloc().add(DeviceAndBluetoothInitialEvent());
    super.initState();

    _subscription =
        _flutterPluginQpos.onPosListenerCalled!.listen((QPOSModel datas) {
      parasListener(datas);
    });

    hoy = format2.format(dateTime);
    body = {
      "transaction_report_request": {
        "status_id": ["PAY"],
        "status": ["APPROVED", "ANULATED"],
        "payment_method_id_set": [],
        "affiliation_number_set": [],
      },
      "cycle_report_request": {
        "status_set": ["OPEN", "PRE_CLOSE"],
        "affiliation_number_set": [],
        "device_id_set": []
      }
    };
    device_id = "";
    getMerchant();

    stateFilter = true;
    today = format.format(DateTime.now());
    type = TextEditingController(text: "");
    status = TextEditingController(text: "");
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
    var results = await cache.getCacheData('merchant');
    var qposid = await cache.getCacheData("qposid");
    setState(() {
      if (qposid != null) {
        device_id = qposid;
      }
      if (results != null) {
        results = ReceiptData.getInformationDevice(json.decode(results!));
        var m = results;
        merchant.addAll(jsonDecode(m!) as Map<String, dynamic>);
        body["transaction_report_request"]
            ["affiliation_number_set"] = [merchant["affiliation_number"]];
        body["cycle_report_request"]["affiliation_number_set"] = [
          merchant["affiliation_number"].toString()
        ];

        body["cycle_report_request"]["device_id_set"] =
            merchant["terminal_set"];
      } else {}
    });
  }

  void clear() {
    setState(() {
      stateFilter = true;
      today = format.format(DateTime.now());
      type = TextEditingController(text: "");
      status = TextEditingController(text: "");

      if (body["transaction_report_request"]
          .containsKey("payment_method_id_set")) {
        body["transaction_report_request"].remove("payment_method_id_set");
      }
      if (body["transaction_report_request"].containsKey("status")) {
        body["transaction_report_request"].remove("status");
      }
      if (body["transaction_report_request"].containsKey("card_holder")) {
        body["transaction_report_request"].remove("card_holder");
      }
      if (body["transaction_report_request"].containsKey("timestamp")) {
        body["transaction_report_request"]["timestamp"] = {
          "lte": "${hoy.replaceAll('/', '-')}T23:59:59.000Z",
          "gte": "${hoy.replaceAll('/', '-')}T00:00:00.000Z",
          "time_zone": dateTime.timeZoneName
        };
      }
    });
  }

  formattedData(data) {
    return DataCell(Text(data));
  }

  void dropdown() {
    DropDownState(
      DropDown(
        bottomSheetTitle: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("TIPO DE TRANSACCIÓN", style: titleStyleText("", 18)),
        ),
        data: _listOfType,
        selectedItems: (List<dynamic> selectedList) {
          for (var item in selectedList) {
            if (item is SelectedListItem) {
              setState(() {
                type.text = item.name;
                body["transaction_report_request"]
                    ["payment_method_id_set"] = [item.value];
                stateFilter = true;
              });
            }
          }
        },
        enableMultipleSelection: false,
      ),
    ).showModal(context);
  }

  generatePopUp(item) {
    return PopupMenuButton(
        itemBuilder: ((context) => <PopupMenuItem>[
              PopupMenuItem(
                  value: 0,
                  child: Text("VER RECIBO", style: subtitleStyleText("", 16))),
              PopupMenuItem(
                  value: 1,
                  child: Text("ANULAR", style: subtitleStyleText("", 16)))
            ]),
        onSelected: (value) {
          if (value == 0) {
            context.goNamed(StaticNames.transactionViewName.name,
                queryParams: {"data": jsonEncode(item)});
          }
        });
  }

  Future<Result<String>> _getLastReport() async {
    var merchant = await cache.getDeviceInformation();
    var id = merchant!.device!.id ?? "";
    Map<String, String> params = {"device_id": id};
    return await getIt<ApiServices>().mlastReport(params);
  }

  futureBuilder() {
    return FutureBuilder(
        future: _getLastReport(),
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
                Map<String, dynamic> mdata = jsonDecode(json) ?? {};
                return dataTable(mdata);
              } else {
                return showErrorMessage("Respuesta Vacia 2");
              }
            }

            var errorMessage =
                result.errorMessage ?? "Error al realizar test de comunicación";

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                showErrorMessage(errorMessage),
              ],
            );
          } else {
            return Center(
              child: Column(
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
                    'Cargando transacciones',
                    style: titleStyleText("", 20),
                  )),
                ],
              ),
            );
          }
        });
  }

  Widget _accountType({String? accountType}) {
    switch (accountType) {
      case "DEBITO":
      case "CORRIENTE":
      case "AHORRO":
      case "PRINCIPAL":
        return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text("NO SE REQUIERE FIRMA",
                    textAlign: TextAlign.center,
                    style: subtitleStyleText("warning", 16)),
                const SizedBox(height: 10)
              ],
            ));
      default:
        return Column(children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Firma:".toUpperCase(), style: titleStyleText("", 16)),
                    const Text("_________________________________"),
                  ])),
          const SizedBox(height: 10),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                  "Me obligo a pagar al banco emisor de esta tarjeta el monto de esta nota de consumo"
                      .toUpperCase(),
                  textAlign: TextAlign.center,
                  style: subtitleStyleText("warning", 16))),
          const SizedBox(height: 10),
        ]);
    }
  }

  dataTable(Map<String, dynamic> data) {
    if (data.isEmpty) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
                child: Text("No hay transacciones",
                    style: subtitleStyleText("gray", 20))),
            Center(
                child: IconButton(
                    onPressed: () => setState(() {}),
                    icon: const Icon(Icons.refresh, size: 40)))
          ]);
    } else {
      var model = LastReportModel.fromJson(data);
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Text(
                      "Esta transacción corresponde a la última transacción realizada por el negocio, independientemente que el lote este abierto o cerrado",
                      textAlign: TextAlign.center,
                      style: subtitleStyleText("gray", 16)),
                )),
            const SizedBox(
              height: 20,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                          child: Text(model.bank_name?.toUpperCase() ?? "",
                              textAlign: TextAlign.center,
                              style: titleStyleText("", 16))),
                      const SizedBox(height: 4),
                      Text("(${model.bank_rif ?? ""})",
                          style: titleStyleText("", 16)),
                      const SizedBox(height: 4),
                      model.status == "APROBADO"
                          ? Text("RECIBO DE COMPRA".toUpperCase(),
                              style: titleStyleText("", 16))
                          : model.status == "ANULADO"
                              ? Text("ANULACIÓN".toUpperCase(),
                                  style: titleStyleText("", 16))
                              : const SizedBox(height: 4),
                      Text(model.card_name?.toUpperCase() ?? "",
                          style: titleStyleText("", 16))
                    ])),
            const SizedBox(height: 10),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            Row(children: [
                              Text(model.name?.toUpperCase() ?? "",
                                  style: subtitleStyleText("", 16)),
                            ]),
                            Row(children: [
                              Text(model.address ?? "",
                                  style: subtitleStyleText("", 16)),
                            ]),
                            Row(children: [
                              Text("RIF: ${model.rif}",
                                  style: subtitleStyleText("", 16)),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                  "Afiliado: ${model.affiliation_number}"
                                      .toUpperCase(),
                                  style: subtitleStyleText("", 16))
                            ]),
                            const SizedBox(height: 4),
                            Text(model.card_mask ?? "",
                                style: titleStyleText("", 16)),
                            const SizedBox(height: 4),
                            Row(children: [
                              Text(
                                  "TERMINAL: ${model.terminal ?? ""}"
                                      .toUpperCase(),
                                  style: subtitleStyleText("", 16)),
                              const SizedBox(
                                width: 6,
                              ),
                              Text("LOTE: ${model.lote ?? ""}",
                                  style: subtitleStyleText("", 16))
                            ]),
                            Row(children: [
                              Text("fecha: ${model.fecha ?? ""}".toUpperCase(),
                                  style: subtitleStyleText("", 16)),
                              const SizedBox(
                                width: 6,
                              ),
                              Text("hora: ${model.hora ?? ""}".toUpperCase(),
                                  style: subtitleStyleText("", 16))
                            ]),
                            const SizedBox(height: 4),
                            model.status == "APROBADO" ||
                                    model.status == "ANULADO"
                                ? Row(
                                    children: [
                                      Text("APROB: ${model.approval ?? ""}",
                                          style: subtitleStyleText("", 16)),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      Text("REF: ${model.reference ?? ""}",
                                          style: subtitleStyleText("", 16)),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                          "TRACE: ${model.sequence?.toString() ?? ""}",
                                          style: subtitleStyleText("", 16)),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      model.reference != null
                                          ? Text(
                                              "REF: ${model.reference ?? ""}",
                                              style: subtitleStyleText("", 16))
                                          : const Text(""),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      model.sequence != null
                                          ? Text(
                                              "TRACE: ${model.sequence?.toString() ?? ""}",
                                              style: subtitleStyleText("", 16))
                                          : const Text(""),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                    ],
                                  ),
                          ]),
                    ]))
          ]),
          model.status == "APROBADO" || model.status == "ANULADO"
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      Center(
                          child: Text("**DUPLICADO**",
                              style: subtitleStyleText("", 16))),
                      Center(
                          child: Text("O", style: subtitleStyleText("", 16))),
                      Center(
                          child: Text("COPIA DEL CLIENTE",
                              style: subtitleStyleText("", 16))),
                    ])
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      Center(
                          child: Text(model.status ?? "",
                              style: subtitleStyleText("", 16))),
                      const SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                              child: Text(model.code ?? "",
                                  style: titleStyleText("", 16))),
                          const SizedBox(width: 4),
                          Center(
                              child: Text(model.message ?? "",
                                  style: titleStyleText("", 16))),
                        ],
                      )
                    ]),
          Column(children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Monto:".toUpperCase(),
                          style: titleStyleText("", 16)),
                      Text(
                        "${model.monto ?? ""}",
                        style: titleStyleText("", 16),
                      ),
                    ])),
            const SizedBox(height: 20),
            model.status != "APROBADO"
                ? const SizedBox(height: 0)
                : _accountType(accountType: model.payment_method),
          ]),
        ],
      );
    }
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
                "ULTIMA TRANSACCIÓN",
                style: titleStyleText("white", 18),
              )),
            ),
            body: futureBuilder());
      },
    );
  }
}
