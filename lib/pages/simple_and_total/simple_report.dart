import 'dart:async';
import 'dart:convert';

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
import 'package:cliff_pickleball/di/injection.dart';
import 'package:cliff_pickleball/pages/abstracts/base_page.dart';
import 'package:cliff_pickleball/services/cacheService.dart';
import 'package:cliff_pickleball/services/http/api_services.dart';
import 'package:cliff_pickleball/styles/bg.dart';
import 'package:cliff_pickleball/styles/text.dart';
import 'package:cliff_pickleball/utils/receipData.dart';
import 'package:cliff_pickleball/utils/staticNamesRoutes.dart';
import 'package:cliff_pickleball/utils/utils.dart';

import '../../blocs/device_and_bluetooth/device_and_bluetooth_bloc.dart';
import '../../services/http/result.dart';
import '../../utils/showErrorMessage.dart';
import '../../utils/translate.dart';
import '../../widgets/isNotBluetoothConnected.dart';
import '../../widgets/simple_receipt.dart';

class SimpleReport extends BasePage {
  final String title;
  final bool total;

  SimpleReport({super.key, required this.title, required this.total});

  @override
  State<SimpleReport> createState() => _SimpleReportState();
}

class _SimpleReportState extends BaseState<SimpleReport> with BasicPage {
  final FlutterPluginQpos _flutterPluginQpos = FlutterPluginQpos();

  StreamSubscription? _subscription;
  QPOSModel? trasactionData;
  final cache = Cache();
  TextEditingController type = TextEditingController(text: "CREDITO");
  late TextEditingController status;
  late TextEditingController _controllerCard;
  late bool stateFilter;
  late Map<String, dynamic> body;
  Map<String, dynamic> merchant = {};
  Map<String, dynamic> sendDataReceipt = {};
  var icon = const Icon(Icons.abc_outlined);
  DateTime dateTime = DateTime.now();
  late Future<Result<String>> _value;
  int page = 0;
  final int limit = 10;
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

  late String today;

  final double pi = 3.1415926535897932;

  final format = DateFormat(
    'DD/MM/Y',
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
    _bloc().add(DeviceAndBluetoothInitialEvent());
    type = TextEditingController(text: "");
    _subscription =
        _flutterPluginQpos.onPosListenerCalled!.listen((QPOSModel datas) {
      parasListener(datas);
    });
    hoy = format2.format(dateTime);
    body = <String, dynamic>{
      "transaction_report_request": {
        "status_id": ["PAY"],
        "status": ["APPROVED", "ANULATED"],
        "affiliation_number_set": [],
      },
      "cycle_report_request": {
        "status_set": ["OPEN", "PRE_CLOSE"],
        "affiliation_number_set": [],
        "device_id_set": ["1031"]
      }
    };
    getMerchant();

    stateFilter = false;
    today = format.format(DateTime.now());

    status = TextEditingController(text: "");
    _controllerCard = TextEditingController(text: "");
    super.initState();
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

  Future<void> getMerchant() async {
    var results = await cache.getDeviceInformation();
    Logger().i(results?.device?.merchantAffiliations![0].toJson());
    setState(() {
      if (results != null) {
        var m = results.device?.merchantAffiliations![0].toJson() ?? {};
        Logger().i(m);
        merchant.addAll(m as Map<String, dynamic>);
        if (merchant.containsKey("terminals")) {
          if (merchant["terminals"].containsKey("CREDIT")) {
            body["cycle_report_request"]
                ["device_id_set"] = [merchant["terminals"]["CREDIT"]];
          }
        }
      } else {}
    });
  }

  void clear() {
    setState(() {
      stateFilter = false;
      today = format.format(DateTime.now());
      type = TextEditingController(text: "");
      status = TextEditingController(text: "");
      _controllerCard = TextEditingController(text: "");

      if (body["transaction_report_request"]
          .containsKey("payment_method_id_set")) {
        body["transaction_report_request"].remove("payment_method_id_set");
        _value = empty();
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
                if (item.value == "CREDITO") {
                  if (merchant.containsKey("terminals")) {
                    if (merchant["terminals"].containsKey("CREDIT")) {
                      body["cycle_report_request"]
                          ["device_id_set"] = [merchant["terminals"]["CREDIT"]];
                      Logger().i(body);
                      _value = getSimpleReport();
                    }
                  }
                }
                if (item.value == "DEBITO") {
                  if (merchant.containsKey("terminals")) {
                    if (merchant["terminals"].containsKey("DEBIT")) {
                      body["cycle_report_request"]
                          ["device_id_set"] = [merchant["terminals"]["DEBIT"]];
                      Logger().i(body);

                      _value = getSimpleReport();
                    }
                  }
                }
                stateFilter = false;
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

  Future<Result<String>> getSimpleReport() async {
    Map<String, String> params = MyUtils.params;
    params["time_zone"] = dateTime.timeZoneName;
    print("merchant -----> ${merchant}");
    body["transaction_report_request"]
        ["affiliation_number_set"] = [merchant["affiliation_number"]];
    body["cycle_report_request"]
        ["affiliation_number_set"] = [merchant["affiliation_number"]];
    print("body -----> ${body}");

    return await getIt<ApiServices>().msimple(params, body);
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
    if (data.containsKey("affiliations")) {
      if (data["affiliation_size"] == 0) {
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
        if (data["affiliations"].length == 0) {
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
        var d = ReceiptData.simpleReceipt(data["affiliations"][0]);
        d["merchant"] = merchant;
        Logger().i(d["merchant"]);
        return SimpleReceipt(data: d, type: widget.total ? "total" : "simple");
      }
    } else {
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
                widget.title,
                style: titleStyleText("white", 18),
              )),
            ),
            body: Column(
              children: [
                InkWell(
                  onTap: () => setState(() {
                    if (body["transaction_report_request"]
                        .containsKey("payment_method_id_set")) {
                      _value = getSimpleReport();
                    }

                    stateFilter = false;
                    if (stateFilter) {
                      if (_controllerCard.text != "") {
                        body["transaction_report_request"]["card_holder"] =
                            _controllerCard.text;
                      }
                    } else {}
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
                              Text("Filtros", style: subtitleStyleText("", 18))
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () => setState(() {
                                        if (body["transaction_report_request"]
                                            .containsKey(
                                                "payment_method_id_set")) {
                                          _value = getSimpleReport();
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
                        const SizedBox(height: 20),
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
                                    icon:
                                        const Icon(Icons.card_travel_outlined),
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
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                futureBuilder()
              ],
            ));
      },
    );
  }
}
