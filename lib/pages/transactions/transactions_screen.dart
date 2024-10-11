import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:collapsible/collapsible.dart';
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
import 'package:pager/pager.dart';
import 'package:cliff_pickleball/di/injection.dart';
import 'package:cliff_pickleball/pages/abstracts/base_page.dart';
import 'package:cliff_pickleball/services/cacheService.dart';
import 'package:cliff_pickleball/services/http/api_services.dart';
import 'package:cliff_pickleball/styles/bg.dart';
import 'package:cliff_pickleball/styles/text.dart';
import 'package:cliff_pickleball/utils/receipData.dart';
import 'package:cliff_pickleball/utils/staticNamesRoutes.dart';
import 'package:cliff_pickleball/widgets/calendary.dart';

import '../../blocs/device_and_bluetooth/device_and_bluetooth_bloc.dart';
import '../../services/http/result.dart';
import '../../utils/showErrorMessage.dart';
import '../../utils/translate.dart';
import '../../widgets/isNotBluetoothConnected.dart';

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }
}

class Transactions extends BasePage {
  Transactions({Key? key}) : super(key: key);

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends BaseState<Transactions> with BasicPage {
  final FlutterPluginQpos _flutterPluginQpos = FlutterPluginQpos();
  StreamSubscription? _subscription;
  QPOSModel? trasactionData;

  final cache = Cache();
  late TextEditingController _controllerInit;
  late TextEditingController _controllerEnd;
  late TextEditingController type;
  late TextEditingController status;
  late TextEditingController _controllerCard;
  bool stateFilter = false;
  late Map<String, dynamic> body;
  final Map<String, dynamic> merchant = {};
  late Future<Result<String>> _value;
  var icon = const Icon(Icons.abc_outlined);
  DateTime dateTime = DateTime.now();
  int totalPages = 1;
  int currentPage = 1;
  int totalcount = 0;

  Map pagingActual = {
    "first_page": {"offset": "0", "limit": "10"},
    "next_page": {"offset": "0", "limit": "10"},
    "last_page": {"offset": "0", "limit": "10"},
    "previous_page": {"offset": "0", "limit": "10"}
  };
  int page = 0;
  bool isFirsLoadRunning = false;
  List transactions = [];

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
    SelectedListItem(
      name: "ANULADAS RECHAZADAS",
      value: "ANULATED_REJECTED",
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

  late String hoy;

  DeviceAndBluetoothBloc _bloc() {
    return context.read<DeviceAndBluetoothBloc>();
  }

  @override
  void initState() {
    _value = empty();
    super.initState();
    _subscription =
        _flutterPluginQpos.onPosListenerCalled!.listen((QPOSModel datas) {
      parasListener(datas);
    });
    hoy = format2.format(dateTime);
    value = 6.28 * 2 / 4;
    body = <String, dynamic>{
      "transaction_report_request": {
        "sorts": {"TIMESTAMP": "desc"},
        "status_id": ["PAY"],
        "includes": [
          "affiliation_number",
          "amount",
          "cycle_id",
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
          "ist_time",
          "ist_date",
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
          "response_code",
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
    // getMerchant();

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

  Future<Result<String>> empty() async {
    return Result.success(
        "{\"message_selected\":\"SELECCIONEUNTIPODETRANSACCIÓN\"}");
  }

  // void getMerchant() async {
  //   var results = await cache.getCacheData('merchant');
  //   setState(() {
  //     if (results != null) {
  //       results = ReceiptData.getInformationDevice(json.decode(results!));
  //       var m = results;
  //       merchant.addAll(jsonDecode(m!) as Map<String, dynamic>);
  //       body["transaction_report_request"]
  //           ["affiliation_number_set"] = [merchant["affiliation_number"]];
  //       body["cycle_report_request"]["affiliation_number_set"] = [
  //         merchant["affiliation_number"].toString()
  //       ];
  //
  //       body["cycle_report_request"]["device_id_set"] =
  //           merchant["terminal_set"];
  //     } else {}
  //     _value = empty();
  //   });
  // }

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
          if (body["transaction_report_request"]
              .containsKey("payment_method_id_set")) {
            body["transaction_report_request"].remove("payment_method_id_set");
          }
          // stateFilter = true;
          _value = empty();
        });
        break;
      case "status":
        status = TextEditingController(text: "");
        if (body["transaction_report_request"].containsKey("status")) {
          body["transaction_report_request"].remove("status");
        }
        if (body["transaction_report_request"]
            .containsKey("payment_method_id_set")) {
          if (body["transaction_report_request"]["payment_method_id_set"] !=
              null) {
            // stateFilter = true;
            _value = getTransactions();
          }
        }

        break;
      default:
        null;
        break;
    }
  }

  void clear() {
    setState(() {
      // stateFilter = true;
      today = format.format(DateTime.now());
      type = TextEditingController(text: "");
      status = TextEditingController(text: "");
      _controllerCard = TextEditingController(text: "");
      _controllerInit = TextEditingController(text: today);
      _controllerEnd = TextEditingController(text: today);

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
      totalcount = 0;
      stateFilter = false;
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("TIPO DE TRANSACCIÓN", style: titleStyleText("", 18)),
              IconButton(
                  onPressed: () {
                    setState(() {
                      clear2("tipo");
                      Navigator.pop(context);
                    });
                  },
                  icon: const Icon(Icons.restore_from_trash_rounded,
                      size: 28, color: ColorUtil.black))
            ],
          ),
        ),
        data: _listOfType,
        selectedItems: (List<dynamic> selectedList) {
          for (var item in selectedList) {
            if (item is SelectedListItem) {
              setState(() {
                type.text = item.name;
                body["transaction_report_request"]
                    ["payment_method_id_set"] = [item.value];
                // stateFilter = true;
                _value = getTransactions();
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
                Timer(const Duration(milliseconds: 100), () {
                  // stateFilter = true;
                });
                if (body["transaction_report_request"]
                    .containsKey("payment_method_id_set")) {
                  if (body["transaction_report_request"]
                          ["payment_method_id_set"] !=
                      null) {
                    _value = getTransactions();
                  }
                }
              });
            }
          }
        },
        enableMultipleSelection: false,
      ),
    ).showModal(context);
  }

  generateModal(item) {
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
                Text('¿Estas seguro que deseas anular la transacción?',
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
                                onPressed: () => context.pop()))),
                    Expanded(
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.fromLTRB(1, 15, 4, 5),
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: ColorUtil.error,
                                    padding: const EdgeInsets.all(20)),
                                child: Text("ANULAR",
                                    selectionColor: ColorUtil.primaryColor(),
                                    style: subtitleStyleText("white", 15)),
                                onPressed: () {
                                  context.goNamed(StaticNames.AnulateName.name,
                                      extra: item);
                                })))
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  generatePopUp(item) {
    var list = <PopupMenuItem>[];
    if (item["status"] == "APROBADO") {
      list = <PopupMenuItem>[
        PopupMenuItem(
            value: 0,
            child: Text("VER RECIBO", style: subtitleStyleText("", 16))),
        PopupMenuItem(
            value: 1, child: Text("ANULAR", style: subtitleStyleText("", 16)))
      ];
    } else {
      list = <PopupMenuItem>[
        PopupMenuItem(
            value: 0,
            child: Text("VER RECIBO", style: subtitleStyleText("", 16)))
      ];
    }
    return PopupMenuButton(
        itemBuilder: ((context) => list),
        onSelected: (value) {
          if (value == 0) {
            context.pop();
            context.goNamed(StaticNames.transactionViewName.name, extra: item);
          }
          if (value == 1) {
            print(item);
            generateModal(item);
          }
        });
  }

  Future<Result<String>> getTransactions() async {
    var d = await cache.getDeviceInformation();
    var merchantData = d?.device?.merchantAffiliations![0];

    body["transaction_report_request"]
        ["affiliation_number_set"] = [merchantData?.affiliationNumber ?? ""];
    body["cycle_report_request"]
        ["affiliation_number_set"] = [merchantData?.affiliationNumber ?? ""];
    body["cycle_report_request"]["device_id_set"] =
        merchantData?.terminalSet?.toList() ?? [];
    // Logger().i(body);

    Map<String, String> params = {
      "offset": pagingActual["first_page"]["offset"],
      "limit": "10"
    };
    if (_controllerCard.text == "") {
      if (body["transaction_report_request"].containsKey("card_holder")) {
        body["transaction_report_request"].remove("card_holder");
      }
    }
    var data = await getIt<ApiServices>().mTransactions(params, body);
    if (data.success) {
      var json = jsonDecode(data.obj!) ?? {};

      if (json.containsKey("count")) {
        setCount(json["count"]);
      }
      if (json.containsKey("first_page")) {
        var first = json["first_page"];
        var off = first.split("&")[0].split("offset=").join("");

        var datas = [off];
        setPaging("first", datas);
      }
      if (json.containsKey("last_page")) {
        var last = json["last_page"];
        var off = last.split("&")[0].split("offset=").join("");
        var datas = [off];
        setPaging("last", datas);
      }
      if (json.containsKey("next_page")) {
        var next = json["next_page"];
        var off = next.split("&")[0].split("offset=").join("");
        var datas = [off];
        setPaging("next", datas);
      }
      if (json.containsKey("previous_page")) {
        var previous = json["previous_page"];
        var off = previous.split("&")[0].split("offset=").join("");
        var datas = [off];
        setPaging("previous", datas);
      }
      return data;
    } else {
      return data;
    }
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

            var errorMessage =
                result.errorMessage ?? "Error al consultar transacciones";

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
            );
          }
        });
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
                      onPressed: () => setState(() {
                            if (body["transaction_report_request"]
                                .containsKey("payment_method_id_set")) {
                              if (body["transaction_report_request"]
                                      ["payment_method_id_set"] !=
                                  null) {
                                _value = getTransactions();
                              }
                            }
                          }),
                      icon: const Icon(Icons.refresh, size: 40)))
            ]);
      }
    }

    if (data.containsKey("results")) {
      if (data["results"].length != 0) {
        //Logger().i(data["results"][0]);
        var list = [];
        for (var i = 0; i < data["results"].length; i++) {
          //print("este es el codigo ${data["results"][i]["response_code"]}");
          list.add(ReceiptData.transactionFormatted(data["results"][i]));
        }

        return SingleChildScrollView(
            child: Column(
          children: list
              .mapIndexed(
                (d, index) => Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(d["fecha"],
                                          style: titleStyleText("gray", 14)),
                                      const SizedBox(width: 5),
                                      Text(d["hora"],
                                          style: titleStyleText("gray", 14)),
                                    ]),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text("AFI: ${d["affiliation_number"]}",
                                          style: subtitleStyleText("gray", 14)),
                                      const SizedBox(width: 5),
                                      Text("TRM: ${d["terminal"]}",
                                          style: subtitleStyleText("gray", 14)),
                                      const SizedBox(width: 5),
                                      Text("LOTE: ${d["lote"]}",
                                          style: subtitleStyleText("gray", 14)),
                                    ]),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text("${d["card_mask"]}",
                                          style: titleStyleText("gray", 14)),
                                      const SizedBox(width: 5),
                                      Text("RIF: ${d["card_holder_id"]}",
                                          style: subtitleStyleText("gray", 14)),
                                    ]),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text("${d["status"]}",
                                          style: titleStyleText("gray", 14)),
                                      const SizedBox(width: 5),
                                      Text("${d["approval"]}",
                                          style: titleStyleText("gray", 14)),
                                    ])
                              ],
                            ),
                            Text(d["monto"],
                                overflow: TextOverflow.fade,
                                style: titleStyleText("gray", 14)),
                            generatePopUp(d)
                          ],
                        ),
                      ),
                      index == list.length - 1
                          ? Pager(
                              currentPage: currentPage,

                              totalPages: totalPages != 0 ? totalPages : 1,

                              // itemsPerPageList: const [10, 20, 50],

                              currentItemsPerPage: int.parse(
                                  pagingActual["first_page"]["limit"]),

                              numberButtonSelectedColor:
                                  ColorUtil.primaryColor(),

                              onItemsPerPageChanged: (p0) {},

                              onPageChanged: (p0) {
                                setState(() {
                                  if (p0 == 1) {
                                    currentPage = 1;

                                    pagingActual["first_page"]["offset"] = "0";

                                    print(pagingActual["first_page"]);
                                    if (body["transaction_report_request"]
                                        .containsKey("payment_method_id_set")) {
                                      if (body["transaction_report_request"]
                                              ["payment_method_id_set"] !=
                                          null) {
                                        _value = getTransactions();
                                      }
                                    }
                                  }

                                  if (p0 == totalPages) {
                                    currentPage = p0;

                                    pagingActual["first_page"]["offset"] =
                                        pagingActual["last_page"]["offset"];

                                    print(pagingActual["first_page"]);
                                    if (body["transaction_report_request"]
                                        .containsKey("payment_method_id_set")) {
                                      if (body["transaction_report_request"]
                                              ["payment_method_id_set"] !=
                                          null) {
                                        _value = getTransactions();
                                      }
                                    }
                                  }

                                  if (p0 > currentPage) {
                                    currentPage = p0;

                                    pagingActual["first_page"]["offset"] =
                                        pagingActual["next_page"]["offset"];

                                    print(pagingActual["first_page"]);
                                    if (body["transaction_report_request"]
                                        .containsKey("payment_method_id_set")) {
                                      if (body["transaction_report_request"]
                                              ["payment_method_id_set"] !=
                                          null) {
                                        _value = getTransactions();
                                      }
                                    }
                                  }

                                  if (p0 < currentPage) {
                                    currentPage = p0;

                                    pagingActual["first_page"]["offset"] =
                                        pagingActual["previous_page"]["offset"];

                                    print(pagingActual["first_page"]);
                                    if (body["transaction_report_request"]
                                        .containsKey("payment_method_id_set")) {
                                      if (body["transaction_report_request"]
                                              ["payment_method_id_set"] !=
                                          null) {
                                        _value = getTransactions();
                                      }
                                    }
                                  }
                                });
                              },
                            )
                          : const SizedBox(height: 2),
                    ],
                  ),
                ),
              )
              .toList(),
        ));
      }
    }
  }

  setCount(int count) {
    setState(() {
      if (count != 0) {
        var c = double.parse(count.toString());
        var limit = int.parse(pagingActual["first_page"]["limit"]);
        var result = (c / limit).ceil();
        print("esta es la cantidad de paginas= " + result.toString());
        print("este es el total= " + c.toString());
        totalPages = result;
        totalcount = count;
      } else {
        totalPages = count;
        totalcount = count;
      }
    });
  }

  setPaging(String page, data) {
    switch (page) {
      case "first":
        setState(() {
          pagingActual["first_page"]["offset"] = data[0];
          pagingActual["first_page"]["limit"] = "10";
        });
        break;
      case "next":
        setState(() {
          pagingActual["next_page"]["offset"] = data[0];
          pagingActual["next_page"]["limit"] = "10";
        });
        break;
      case "previous":
        setState(() {
          pagingActual["previous_page"]["offset"] = data[0];
          pagingActual["previous_page"]["limit"] = "10";
        });
        break;
      case "last":
        setState(() {
          pagingActual["last_page"]["offset"] = data[0];
          pagingActual["last_page"]["limit"] = "10";
        });
        break;
      default:
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
              message: "No hay dispositivo conectado");
        }
        return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              elevation: 0,
              title: Center(
                  child: Text(
                "TRANSACCIONES",
                style: titleStyleText("white", 18),
              )),
              leading: IconButton(
                  onPressed: (() => context.pop()),
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
                              _value = getTransactions();
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
                                                  "payment_method_id_set")) {
                                            if (body["transaction_report_request"]
                                                    ["payment_method_id_set"] !=
                                                null) {
                                              _value = getTransactions();
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
                                const SizedBox(width: 5),
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
                              showCursor: false,
                              mouseCursor: MouseCursor.uncontrolled,
                              onTap: () {
                                Calendary.pickDateDialog(context, (date) {
                                  if (date.isAfter(DateTime.parse(_controllerEnd
                                      .text
                                      .replaceAll("/", "-")))) {
                                  } else {
                                    setState(() {
                                      value = 6.28 * 2 / 4;
                                      stateFilter = true;
                                      _controllerInit.text =
                                          format.format(date);
                                      if (body["transaction_report_request"]
                                          .containsKey("timestamp")) {
                                        if (body["transaction_report_request"]
                                                ["timestamp"]
                                            .containsKey("gte")) {
                                          body["transaction_report_request"]
                                                  ["timestamp"]["gte"] =
                                              format2.format(date) +
                                                  "T00:00:00.000Z";
                                        }
                                      }
                                      if (body["transaction_report_request"]
                                          .containsKey(
                                              "payment_method_id_set")) {
                                        if (body["transaction_report_request"]
                                                ["payment_method_id_set"] !=
                                            null) {
                                          _value = getTransactions();
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
                                } else {
                                  return null;
                                }
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
                                border: const OutlineInputBorder(),
                                label: Text("Fecha inicio",
                                    style: subtitleStyleText("", 15)),
                                hintText: 'Fecha inicio',
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              showCursor: false,
                              mouseCursor: MouseCursor.uncontrolled,
                              onTap: () =>
                                  Calendary.pickDateDialog(context, (date) {
                                print(format2.format(date) + "T23:59:59.000Z");
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
                                            format2.format(date) +
                                                "T23:59:59.000Z";
                                      }
                                    }
                                    if (body["transaction_report_request"]
                                        .containsKey("payment_method_id")) {
                                      if (body["transaction_report_request"]
                                              ["payment_method_id"] !=
                                          null) {
                                        _value = getTransactions();
                                      }
                                    }
                                  });
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
                                } else {
                                  return null;
                                }
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
                                border: const OutlineInputBorder(),
                                hintText: 'Fecha fin',
                              ),
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
                                readOnly: false,
                                enabled: false,
                                controller: type,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: () {},
                                    icon:
                                        const Icon(Icons.card_travel_outlined),
                                  ),
                                  label: Text("Tipo de transacción",
                                      style: subtitleStyleText("", 15)),
                                  border: const OutlineInputBorder(),
                                  hintText: '',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: InkWell(
                              onTap: () {
                                dropdownStatus();
                              },
                              child: TextFormField(
                                readOnly: false,
                                enabled: false,
                                controller: status,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                        Icons.expand_circle_down_sharp),
                                  ),
                                  label: Text("Estatus",
                                      style: subtitleStyleText("", 15)),
                                  border: const OutlineInputBorder(),
                                  hintText: '',
                                ),
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
                                                  "payment_method_id_set")) {
                                            if (body["transaction_report_request"]
                                                    ["payment_method_id_set"] !=
                                                null) {
                                              _value = getTransactions();
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
                  const SizedBox(height: 10),
                  totalcount != 0
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text("Total: $totalcount",
                                        style: titleStyleText("grey", 16))
                                  ]),
                              const SizedBox(height: 10),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  futureBuilder()
                ],
              ),
            ));
      },
    );
  }
}
