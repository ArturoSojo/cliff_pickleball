import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:collapsible/collapsible.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_plugin_qpos/QPOSModel.dart';
import 'package:flutter_plugin_qpos/flutter_plugin_qpos.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:cliff_pickleball/di/injection.dart';
import 'package:cliff_pickleball/domain/merchant_device_response.dart';
import 'package:cliff_pickleball/pages/abstracts/base_page.dart';
import 'package:cliff_pickleball/services/cacheService.dart';
import 'package:cliff_pickleball/services/http/api_services.dart';
import 'package:cliff_pickleball/styles/bg.dart';
import 'package:cliff_pickleball/styles/text.dart';
import 'package:cliff_pickleball/utils/receipData.dart';
import 'package:cliff_pickleball/widgets/calendary.dart';

import '../blocs/device_and_bluetooth/device_and_bluetooth_bloc.dart';
import '../services/http/result.dart';
import '../utils/showErrorMessage.dart';
import '../utils/translate.dart';
import '../widgets/isNotBluetoothConnected.dart';

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }
}

class DetailsReport extends BasePage {
  DetailsReport({Key? key}) : super(key: key);

  @override
  State<DetailsReport> createState() => _DetailsReportState();
}

class _DetailsReportState extends BaseState<DetailsReport> with BasicPage {
  final FlutterPluginQpos _flutterPluginQpos = FlutterPluginQpos();
  StreamSubscription? _subscription;

  QPOSModel? trasactionData;
  final cache = Cache();
  late TextEditingController _controllerInit;
  late TextEditingController _controllerEnd;
  late TextEditingController type;
  late TextEditingController status;
  late TextEditingController _controllerCard;
  final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter(
    symbol: "Bs. ",
    decimalDigits: 2,
  );
  MerchantDeviceResponse? merchantResponse = null;
  bool stateFilter = false;
  late Map<String, dynamic> body;
  late Map headerList = {};
  Map<String, dynamic> merchant = {};
  var icon = const Icon(Icons.abc_outlined);
  DateTime dateTime = DateTime.now();

  int page = 0;
  final int limit = 10;
  bool isFirsLoadRunning = false;
  List detailsReport = [];
  late Future<Result<String>> _value;

  final List columns = [
    "Fecha",
    'Tipo',
    'Tarjetahabiente',
    'Afiliación',
    'Lote',
    'Monto',
    'Aprobación',
    'Estatus',
    ''
  ];
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
  final List<SelectedListItem> _listStatus = [
    SelectedListItem(
      name: "APROBADO",
      value: "APPROVED",
      isSelected: false,
    ),
    SelectedListItem(
      name: "ANULADO",
      value: "ANULATED",
      isSelected: false,
    ),
    SelectedListItem(
      name: "FALLIDAS",
      value: "FAILED",
      isSelected: false,
    ),
    SelectedListItem(
      name: "RECHAZADAS",
      value: "REJECTED",
      isSelected: false,
    ),
  ];

  late String today;

  final double pi = 3.1415926535897932;
  late double value;
  final format = DateFormat(
    'y/MM/dd',
  );
  final format2 = DateFormat(
    'y-MM-dd',
  );
  final format3 = DateFormat('hh:mm:ss a');
  late String hoy;

  DeviceAndBluetoothBloc _bloc() {
    return context.read<DeviceAndBluetoothBloc>();
  }

  @override
  void initState() {
    _bloc().add(DeviceAndBluetoothInitialEvent());
    super.initState();
    _value = empty();
    _subscription =
        _flutterPluginQpos.onPosListenerCalled!.listen((QPOSModel datas) {
      parasListener(datas);
    });
    headerList = {};
    hoy = format2.format(dateTime);
    value = 6.28 * 2 / 4;
    body = <String, dynamic>{
      "transaction_report_request": {
        "status": ["APPROVED", "ANULATED"],
        "sorts": {"TIMESTAMP": "desc"},
        "status_id": ["PAY"],
        "includes": [
          "affiliation_number",
          "amount",
          "account_type",
          "profile_id_acquiring",
          "order_number",
          "card_holder_id",
          "card_holder_number_mask",
          "card_name",
          "coin",
          "collector_bank_name",
          "collector_bank_rif",
          "collector_id_doc",
          "collector_name",
          "payment_method_id",
          "timestamp",
          "device_id",
          "status",
          "approval",
          "lot_number",
          "reference",
          "sequence",
          "status_id",
          "card_holder",
          "store",
          "message",
          "id"
        ],
        "affiliation_number_set": [],
        "timestamp": {
          "lte": "${hoy.replaceAll('/', '-')}T23:59:59.000Z",
          "gte": "${hoy.replaceAll('/', '-')}T00:00:00.000Z",
          "time_zone": dateTime.timeZoneName
        },
      },
      "cycle_report_request": {
        "status_set": ["OPEN", "PRE_CLOSE"],
        "affiliation_number_set": [],
        "device_id_set": []
      }
    };
    getMerchant();

    stateFilter = false;
    today = format.format(DateTime.now());
    type = TextEditingController(text: "");
    status = TextEditingController(text: "");
    _controllerCard = TextEditingController(text: "");
    _controllerInit = TextEditingController(text: today);
    _controllerEnd = TextEditingController(text: today);
  }

  @override
  void dispose() {
    super.dispose();
    if (_subscription != null) {
      _subscription!.cancel();
    }
  }

  listenerCard() {
    _controllerCard.addListener(() {
      setState(() {
        _value = getDetailsReport();
      });
    });
  }

  Future<Result<String>> empty() async {
    return Result.success(
        "{\"message_selected\":\"SELECCIONEUNTIPODETRANSACCIÓN\"}");
  }

  void getMerchant() async {
    var results = await cache.getDeviceInformation();
    setState(() {
      if (results != null) {
        merchantResponse = results;
        merchant = results.device!.merchantAffiliations![0].toJson();
        var m = results;
        body["transaction_report_request"]
            ["affiliation_number_set"] = [merchant["affiliation_number"]];
        body["cycle_report_request"]["affiliation_number_set"] = [
          merchant["affiliation_number"].toString()
        ];

        print(merchant);
      } else {}
    });
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

  void clear2(String val) {
    switch (val) {
      case "fecha":
        setState(() {
          _controllerInit = TextEditingController(text: today);
          _controllerEnd = TextEditingController(text: today);
        });
        break;
      case "tipo":
        setState(() {
          type = TextEditingController(text: "");
          body["transaction_report_request"].remove("payment_method_id");
          body["transaction_report_request"].remove("device_id_set");
        });
        break;
      case "status":
        status = TextEditingController(text: "");
        if (body["transaction_report_request"].containsKey("status")) {
          body["transaction_report_request"].remove("status");
        }
        break;
      default:
        null;
        break;
    }
  }

  void clear() {
    setState(() {
      stateFilter = false;
      today = format.format(DateTime.now());
      type = TextEditingController(text: "");
      status = TextEditingController(text: "");
      _controllerCard = TextEditingController(text: "");
      _controllerInit = TextEditingController(text: today);
      _controllerEnd = TextEditingController(text: today);

      if (body["transaction_report_request"].containsKey("payment_method_id")) {
        body["transaction_report_request"].remove("payment_method_id");
        body["transaction_report_request"].remove("device_id_set");
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
      if (body["transaction_report_request"].containsKey("payment_method_id")) {
        if (body["payment_method_id"] != null) {
          _value = getDetailsReport();
        }
      }
      _value = empty();
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
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("TIPO DE TRANSACCIÓN", style: titleStyleText("", 18)),
            IconButton(
                onPressed: () {
                  setState(() {
                    clear2("tipo");
                    value = 6.28 * 2 / 4;
                    stateFilter = true;
                    Navigator.pop(context);
                  });
                },
                icon: const Icon(Icons.restore_from_trash_rounded,
                    size: 28, color: ColorUtil.black))
          ]),
        ),
        data: _listOfType,
        selectedItems: (List<dynamic> selectedList) {
          for (var item in selectedList) {
            if (item is SelectedListItem) {
              setState(() {
                type.text = item.name;
                body["transaction_report_request"]
                    ["payment_method_id"] = [item.value];
                body["cycle_report_request"]["device_id_set"] =
                    item.value == "CREDITO"
                        ? [merchant["terminals"]["CREDIT"]]
                        : item.value == "DEBITO"
                            ? [merchant["terminals"]["DEBIT"]]
                            : "";
                // value = 6.28 * 2 / 4;
                stateFilter = false;
                _value = getDetailsReport();
              });
            }
          }
        },
        enableMultipleSelection: false,
      ),
    ).showModal(context);
  }

  void dropdownStatus() {
    DropDownState(
      DropDown(
        bottomSheetTitle: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Estatus", style: titleStyleText("", 18)),
              IconButton(
                  onPressed: () {
                    setState(() {
                      clear2("status");
                      value = 6.28 * 2 / 4;
                      stateFilter = true;
                      Navigator.pop(context);
                    });
                  },
                  icon: const Icon(Icons.restore_from_trash_rounded,
                      size: 28, color: ColorUtil.black))
            ],
          ),
        ),
        data: _listStatus,
        selectedItems: (List<dynamic> selectedList) {
          for (var item in selectedList) {
            if (item is SelectedListItem) {
              setState(() {
                status.text = item.name;
                body["transaction_report_request"]["status"] = [item.value];
                Timer(
                    const Duration(milliseconds: 100),
                    (() => setState(() {
                          value = 6.28 * 2 / 4;
                          stateFilter = true;
                        })));
              });
            }
          }
        },
        enableMultipleSelection: false,
      ),
    ).showModal(context);
  }

  Future<Result<String>> getDetailsReport() async {
    if (_controllerCard.text == "") {
      if (body["transaction_report_request"].containsKey("card_holder")) {
        body["transaction_report_request"].remove("card_holder");
      }
    }
    return await getIt<ApiServices>().mdetail(body);
  }

  futureBuilder() {
    return FutureBuilder(
        future: _value,
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

            var errorMessage = result.errorMessage ??
                "Error al consultar detalle de transacciones";

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                showErrorMessage(errorMessage),
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
                          color: ColorUtil.primaryLightColor(),
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
            );
          }
        });
  }

  headerWidget(merchant, list) {
    if (merchant.isNotEmpty) {
      return Column(children: [
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
                      child: Text(merchant["bank_name"].toUpperCase(),
                          textAlign: TextAlign.center,
                          style: titleStyleText("", 16))),
                  const SizedBox(height: 4),
                  Text("(${merchant["bank_rif"]})",
                      style: titleStyleText("", 16)),
                  const SizedBox(height: 4),
                  Center(
                    child: Text(
                        "REPORTE DETALLADO DE TRANSACCIONES".toUpperCase(),
                        textAlign: TextAlign.center,
                        style: titleStyleText("", 16)),
                  ),
                  const SizedBox(height: 12),
                ])),
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
                        const SizedBox(height: 4),
                        merchantResponse!.device!.commerceName != null
                            ? Text(
                                merchantResponse!.device!.commerceName!
                                    .toUpperCase(),
                                style: subtitleStyleText("", 16))
                            : const SizedBox(),
                        const SizedBox(height: 4),
                        merchantResponse!.device!.store!.address != null
                            ? Text(
                                merchantResponse!.device!.store!.address ?? "",
                                style: subtitleStyleText("", 16))
                            : const SizedBox(),
                        const SizedBox(height: 4),
                        merchantResponse!.device!.commerceIdDoc != null
                            ? Row(children: [
                                Text(
                                    "RIF: ${merchantResponse!.device!.commerceIdDoc}",
                                    style: subtitleStyleText("", 16)),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text(
                                    "Afiliado: ${merchantResponse!.device!.merchantAffiliations![0].affiliationNumber}"
                                        .toUpperCase(),
                                    style: subtitleStyleText("", 16))
                              ])
                            : const SizedBox(),
                        const SizedBox(height: 4),
                        merchantResponse!.device!.merchantAffiliations![0]
                                    .terminalSet!.length !=
                                0
                            ? Row(children: [
                                Text(
                                    "TERMINAL: ${list["terminal"]}"
                                        .toUpperCase(),
                                    style: subtitleStyleText("", 16)),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text("LOTE: ${list["lote"]}",
                                    style: subtitleStyleText("", 16))
                              ])
                            : const SizedBox(),
                        const SizedBox(height: 4),
                        Row(children: [
                          Text("fecha: ${list["fecha"]}".toUpperCase(),
                              style: subtitleStyleText("", 16)),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                              "hora: ${format3.format(dateTime)}".toUpperCase(),
                              style: subtitleStyleText("", 16))
                        ]),
                      ]),
                ])),
        const SizedBox(height: 10),
      ]);
    }
    return Row();
  }

  dataTable(Map<String, dynamic> data) {
    if (data.containsKey("message_selected")) {
      return const Center(
          child: Text("SELECCIONE UN TIPO DE TRANSACCIÓN",
              style: TitleTextStyle(fontSize: 16)));
    }
    if (data.containsKey("count")) {
      if (data["count"] == 0) {
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
      }
    }

    if (data.containsKey("results")) {
      if (data["results"].length != 0) {
        var list = [];

        for (var i = 0; i < data["results"].length; i++) {
          if (data["results"][i]["status"] != "REJECTED") {
            list.add(ReceiptData.transactionFormatted(data["results"][i]));
          }
        }
        int m = 0;
        int s = 0;
        int c = 0;
        var amounts = (data["results"]).map((data) {
          if (data.containsKey("amount")) {
            print(data["status"]);
            if (data["status"] == "APPROVED" || data["status"] == "ANULATED") {
              m++;
              return data["amount"];
            } else {
              return 0;
            }
          }
        }).toList();
        var successAmounts = (data["results"]).map((data) {
          if (data.containsKey("amount")) {
            if (data["status"] == "APPROVED") {
              c++;
              return data["amount"];
            } else {
              return 0;
            }
          }
        }).toList();
        var anulateAmounts = (data["results"]).map((data) {
          if (data.containsKey("status")) {
            if (data["status"] == "ANULATED") {
              s++;
              return data["amount"];
            } else {
              return 0;
            }
          }
        }).toList();

        print(successAmounts);
        print(anulateAmounts);
        print(amounts);

        var anulate = anulateAmounts.reduce((a, b) => a + b);
        var compra = successAmounts.reduce((a, b) => a + b);
        var total = (compra - anulate).toString();

        anulate = anulate.toString();
        compra = compra.toString();
        m = m - s;
        return SingleChildScrollView(
            child: Column(
          children: list
              .mapIndexed(
                (d, index) => Column(
                  children: [
                    index == 0
                        ? headerWidget(merchant, list[0])
                        : const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          d["reference"] == null ||
                                  d["reference"] == "null" ||
                                  d["reference"] == ""
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      Text(
                                        d["card_mask"],
                                        style: titleStyleText("", 14),
                                      ),
                                      Text(
                                        d["status"],
                                        style: subtitleStyleText("", 14),
                                      ),
                                    ])
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      Text(
                                        "REF: ${d["reference"]}",
                                        style: subtitleStyleText("", 14),
                                      ),
                                      Text(
                                        d["card_mask"],
                                        style: titleStyleText("", 14),
                                      ),
                                      Text(
                                        d["status"],
                                        style: subtitleStyleText("", 14),
                                      ),
                                    ]),
                          d["reference"] == null ||
                                  d["reference"] == "null" ||
                                  d["reference"] == ""
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      Text(
                                        d["type"].toString(),
                                        style: subtitleStyleText("", 14),
                                      ),
                                      Text(
                                        "${d["fecha"]}",
                                        style: subtitleStyleText("", 14),
                                      ),
                                      Text(
                                        "${d["monto"]}",
                                        style: subtitleStyleText("", 14),
                                      ),
                                    ])
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      Text(
                                        d["card_name"].toString(),
                                        style: subtitleStyleText("", 14),
                                      ),
                                      Text(
                                        d["type"].toString(),
                                        style: subtitleStyleText("", 14),
                                      ),
                                    ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${d["fecha"]}",
                                  style: subtitleStyleText("", 14),
                                ),
                                Text(
                                  "${d["monto"]}",
                                  style: subtitleStyleText("", 14),
                                ),
                              ]),
                        ],
                      ),
                    ),
                    index == list.length - 1
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Column(
                              children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text("COMPRA (${c.toString()})",
                                          style: titleStyleText("", 16)),
                                      Text(_formatter.format(compra),
                                          style: titleStyleText("", 16)),
                                    ]),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("ANULADAS (${s.toString()})",
                                        style: titleStyleText("", 16)),
                                    Text(_formatter.format(anulate),
                                        style: titleStyleText("", 16)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("TOTAL (${(m - s).toString()})",
                                        style: titleStyleText("", 16)),
                                    Text(_formatter.format(total),
                                        style: titleStyleText("", 16)),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
              )
              .toList(),
        ));
      }
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
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              elevation: 0,
              title: Center(
                  child: Text(
                "REPORTE DETALLADO DE TRANSACCIONES",
                style: titleStyleText("white", 15),
              )),
              leading: IconButton(
                  onPressed: (() => Navigator.pop(context)),
                  icon: const Icon(Icons.arrow_back_sharp)),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () => setState(() {
                      stateFilter = !stateFilter;
                      if (stateFilter) {
                        value = 6.28 * 2 / 4;
                        if (_controllerCard.text != "") {
                          body["transaction_report_request"]["card_holder"] =
                              _controllerCard.text;
                          if (body["transaction_report_request"]
                              .containsKey("payment_method_id")) {
                            if (body["transaction_report_request"]
                                    ["payment_method_id"] !=
                                null) {
                              _value = getDetailsReport();
                            }
                          }
                        }
                      } else {
                        value = 6.28;
                      }
                    }),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(Icons.filter_alt_outlined,
                                    color: ColorUtil.black, size: 20),
                                const SizedBox(width: 8),
                                Text("Filtros",
                                    style: subtitleStyleText("", 18))
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () => setState(() {
                                          if (body["transaction_report_request"]
                                              .containsKey(
                                                  "payment_method_id")) {
                                            if (body["transaction_report_request"]
                                                    ["payment_method_id"] !=
                                                null) {
                                              _value = getDetailsReport();
                                            }
                                          }
                                        }),
                                    icon: const Icon(Icons.refresh,
                                        size: 28, color: ColorUtil.black)),
                                IconButton(
                                  onPressed: () => clear(),
                                  icon: const Icon(
                                      Icons.restore_from_trash_rounded,
                                      size: 28,
                                      color: ColorUtil.black),
                                ),
                                AnimatedRotation(
                                    turns: -pi / value,
                                    duration: const Duration(milliseconds: 200),
                                    child: const Icon(
                                        Icons.expand_circle_down_sharp,
                                        color: ColorUtil.black,
                                        size: 24)),
                              ],
                            )
                          ],
                        )),
                  ),
                  Collapsible(
                    collapsed: stateFilter,
                    axis: CollapsibleAxis.vertical,
                    duration: const Duration(milliseconds: 400),
                    child: Form(
                      autovalidateMode: AutovalidateMode.always,
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              cursorColor: ColorUtil.primaryLightColor(),
                              showCursor: false,
                              mouseCursor: MouseCursor.uncontrolled,
                              onTap: () {
                                Calendary.pickDateDialog(context, (date) {
                                  if (date.isAfter(DateTime.parse(_controllerEnd
                                      .text
                                      .replaceAll("/", "-")))) {
                                  } else {
                                    setState(() {
                                      // value = 6.28 * 2 / 4;
                                      Logger().i(body);
                                      stateFilter = false;
                                      _controllerInit.text =
                                          format.format(date);
                                      if (body["transaction_report_request"]
                                          .containsKey("timestamp")) {
                                        if (body["transaction_report_request"]
                                                ["timestamp"]
                                            .containsKey("gte")) {
                                          body["transaction_report_request"]
                                                  ["timestamp"]["gte"] =
                                              "${format2.format(date)}T00:00:00.000Z";
                                        }
                                      }
                                      if (body["transaction_report_request"]
                                          .containsKey("payment_method_id")) {
                                        if (body["transaction_report_request"]
                                                ["payment_method_id"] !=
                                            null) {
                                          // Logger().i("llamando a getDetailsReport");
                                          _value = getDetailsReport();
                                        }
                                      }
                                    });
                                  }
                                });
                              },
                              validator: ((value) {
                                if (value!.isNotEmpty) {
                                  if (DateTime.parse(value.replaceAll("/", "-"))
                                      .isAfter(DateTime.parse(_controllerEnd
                                          .text
                                          .replaceAll("/", "-")))) {
                                    return "La fecha de inicio no puede ser mayor a la fecha de fin";
                                  }
                                }
                                return null;
                              }),
                              keyboardType: TextInputType.none,
                              readOnly: false,
                              enabled: true,
                              controller: _controllerInit,
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.calendar_month),
                                  ),
                                  focusColor: ColorUtil.primaryColor(),
                                  border: const OutlineInputBorder(),
                                  label: Text("Fecha inicio",
                                      style: subtitleStyleText("", 15)),
                                  hintText: 'Fecha inicio',
                                  fillColor: ColorUtil.primaryColor()),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              cursorColor: ColorUtil.primaryLightColor(),
                              showCursor: false,
                              mouseCursor: MouseCursor.uncontrolled,
                              onTap: () =>
                                  Calendary.pickDateDialog(context, (date) {
                                print("${format2.format(date)}T23:59:59.000Z");
                                if (date.isBefore(DateTime.parse(_controllerInit
                                    .text
                                    .replaceAll("/", "-")))) {
                                } else {
                                  setState(() {
                                    // value = 6.28 * 2 / 4;
                                    stateFilter = false;
                                    _controllerEnd.text = format.format(date);
                                    if (body["transaction_report_request"]
                                        .containsKey("timestamp")) {
                                      if (body["transaction_report_request"]
                                              ["timestamp"]
                                          .containsKey("lte")) {
                                        body["transaction_report_request"]
                                                ["timestamp"]["lte"] =
                                            "${format2.format(date)}T23:59:59.000Z";
                                      }
                                    }
                                  });
                                  if (body["transaction_report_request"]
                                      .containsKey("payment_method_id")) {
                                    if (body["transaction_report_request"]
                                            ["payment_method_id"] !=
                                        null) {
                                      setState(() {
                                        _value = getDetailsReport();
                                      });
                                    }
                                  }
                                }
                              }),
                              keyboardType: TextInputType.none,
                              validator: (value) {
                                if (value!.isNotEmpty) {
                                  if (DateTime.parse(value.replaceAll("/", "-"))
                                      .isBefore(DateTime.parse(_controllerInit
                                          .text
                                          .replaceAll("/", "-")))) {
                                    return "La fecha fin no puede ser menor a la fecha de inicio";
                                  }
                                }
                                return null;
                              },
                              readOnly: false,
                              controller: _controllerEnd,
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.calendar_month),
                                  ),
                                  label: Text("Fecha fin",
                                      style: subtitleStyleText("", 15)),
                                  focusColor: ColorUtil.primaryColor(),
                                  border: const OutlineInputBorder(),
                                  hintText: 'Fecha fin',
                                  fillColor: ColorUtil.primaryColor()),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: InkWell(
                              onTap: () {
                                dropdown();
                              },
                              child: TextFormField(
                                cursorColor: ColorUtil.primaryLightColor(),
                                readOnly: false,
                                enabled: false,
                                controller: type,
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                          Icons.card_travel_outlined),
                                    ),
                                    label: Text("Tipo de transacción",
                                        style: subtitleStyleText("", 15)),
                                    focusColor: ColorUtil.primaryColor(),
                                    border: const OutlineInputBorder(),
                                    hintText: '',
                                    fillColor: ColorUtil.primaryColor()),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              cursorColor: ColorUtil.primaryLightColor(),
                              maxLength: 20,
                              readOnly: false,
                              controller: _controllerCard,
                              decoration: InputDecoration(
                                  label: Text(
                                      "Tarjetahabiente (C.I/RIF, nombre)",
                                      style: subtitleStyleText("", 15)),
                                  focusColor: ColorUtil.primaryColor(),
                                  border: const OutlineInputBorder(),
                                  hintText: 'Ingresa C.I/RIF, nombre',
                                  fillColor: ColorUtil.primaryColor(),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if (_controllerCard.text != "") {
                                            body["transaction_report_request"]
                                                    ["card_holder"] =
                                                _controllerCard.text;
                                          }
                                          if (body["transaction_report_request"]
                                              .containsKey(
                                                  "payment_method_id")) {
                                            if (body["transaction_report_request"]
                                                    ["payment_method_id"] !=
                                                null) {
                                              _value = getDetailsReport();
                                            }
                                          }
                                        });
                                      },
                                      icon: const Icon(Icons.search))),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                  // merchant.isNotEmpty
                  //     ? headerWidget(merchant)
                  //     : const SizedBox(height: 10),
                  futureBuilder()
                ],
              ),
            ));
      },
    );
  }
}
