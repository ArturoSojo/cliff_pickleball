import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_plugin_qpos/QPOSModel.dart';
import 'package:flutter_plugin_qpos/flutter_plugin_qpos.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:cliff_pickleball/domain/device.dart';
import 'package:cliff_pickleball/domain/initDataModel.dart';
import 'package:cliff_pickleball/domain/rolesModel.dart';
import 'package:cliff_pickleball/pages/abstracts/base_page.dart';
import 'package:cliff_pickleball/pages/pos/bloc/pos_eq_bloc.dart';
import 'package:cliff_pickleball/pages/pos/pos_widget.dart';
import 'package:cliff_pickleball/pages/sales/bloc/sales_eq_bloc.dart';
import 'package:cliff_pickleball/pages/sales/sales_widget.dart';
import 'package:cliff_pickleball/services/http/domain/productModel.dart';
import 'package:cliff_pickleball/styles/domain/app_theme.dart';
import 'package:cliff_pickleball/utils/staticNamesRoutes.dart';
import 'package:cliff_pickleball/widgets/isNotBluetoothConnected.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_headers/sticky_headers.dart';

import '../blocs/device_and_bluetooth/device_and_bluetooth_bloc.dart';
import '../di/injection.dart';
import '../services/cacheService.dart';
import '../styles/bg.dart';
import '../styles/text.dart';
import '../styles/theme_provider.dart';

class HomePage extends BasePage {
  HomePage({Key? key})
      : super(
          key: key,
        );

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BaseState<HomePage> with BasicPage {
  late SharedPreferences prefs;
  ScrollController scrollController = ScrollController();
  final userController = TextEditingController();
  String pageSelected = "pos";
  final _cache = Cache();
  Device? _device;
  RolesModel? _rolesConfirmed;
  DateTime date = DateTime.now();
  final testProductPre = ProductModel(
    category: "RECARGA",
    name: "ARIESCO_MOVISTAR_PREPAID",
    company: "MOVISTAR",
    status: "ACTIVE",
    features: Features(
      MIN: 1,
      MAX: 100,
      MULTIPLE: 2,
    ),
  );
  final testProductPos = ProductModel(
    category: "POSPAGO",
    name: "MOVISTAR_POSPAID",
    company: "MOVISTAR",
    status: "ACTIVE",
  );
  int viewsDisplayed = 10;

  DeviceAndBluetoothBloc _bloc() {
    return context.read<DeviceAndBluetoothBloc>();
  }

  @override
  void initState() {
    _bloc().add(DeviceAndBluetoothInitialEvent());
    getCache();
    _isLogged();
    super.initState();
    initPrefs();
    getRolesConfirmed();
    // Cache().emptyCache_appTheme();
  }

  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  void parasListener(QPOSModel qposModel) {
    String? method = qposModel.method;
    List<String> paras = List.empty();

    String? parameters = qposModel.parameters;

    if (parameters != null && parameters.isNotEmpty) {
      paras = parameters.split("||");
    }

    switch (method) {
      case 'onRequestQposDisconnected':
        break;
    }
  }

  connecteBT() {
    _bloc().getInitState();
    scrollController.animateTo(0.0,
        duration: const Duration(microseconds: 1), curve: Curves.linear);
    return Column(
      children: const [
        SizedBox(height: 100),
        IsNotBluetoothConnected(message: "No hay dispositivo conectado"),
        SizedBox(height: 110)
      ],
    );
  }

  setFormattedDate() {
    var formatted = DateFormat("dd/MM/yyyy");
    return formatted.format(date);
  }

  void _isLogged() async {
    bool isLoggedIn = await _cache.getAccessTokenResponse() != null;
    print("la sesion esta en $isLoggedIn");
    if (!isLoggedIn) {
      // ignore: use_build_context_synchronously
      context.go(StaticNames.loginName.path);
    }
  }

  getCache() async {
    var device2 = await _cache.getDeviceInformation();

    if (device2 != null) {
      setState(() {
        _device = device2.device;
      });
    }
  }

  getRolesConfirmed() async {
    var roles = await _cache.getRoles();
    if (roles != null) {
      setState(() {
        _rolesConfirmed = roles;
      });
    }
  }

  getNotNullRoles(String role) {
    if (_rolesConfirmed == null) {
      return false;
    } else {
      if (role == "pinpagos") {
        return _rolesConfirmed?.pinpagos;
      } else {
        return _rolesConfirmed?.servicepay;
      }
    }
  }

  AppTheme appTheme() {
    return getIt<ThemeProvider>().appTheme();
  }

  @override
  Widget rootWidget(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final appTheme = this.appTheme();

    return BlocConsumer<DeviceAndBluetoothBloc, DeviceAndBluetoothState>(
        bloc: _bloc(),
        listener: (context, state) async {
          if (state is DeviceAndBluetoothInitialEvent) {
            await _bloc().getBluetoothDevice();
          }
        },
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                title: Center(
                    child: _device == null
                        ? const SizedBox()
                        : _device!.sellerName != null
                            ? Text(
                                "${_device!.sellerName} (${_device!.sellerIdDoc})",
                                style: titleStyleText("white", 20))
                            : const SizedBox(height: 0)),
              ),
              backgroundColor: ColorUtil.white,
              body: SafeArea(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 10),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 0),
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 20, bottom: 2.5),
                            decoration: BoxDecoration(
                                color: ColorUtil.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  transform:
                                      Matrix4.translationValues(-10, -25, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(
                                            Icons.home,
                                            size: 30,
                                            color: ColorUtil.primaryColor(),
                                          ),
                                          const SizedBox(width: 2),
                                          Text(setFormattedDate(),
                                              style: subtitleStyleText("", 18))
                                        ],
                                      ),
                                      Container(
                                        transform:
                                            Matrix4.translationValues(0, 10, 0),
                                        child: FutureBuilder(
                                            future: _cache.getProfile(),
                                            initialData: Profile(
                                                businessName: "Cargando",
                                                idDoc: "Cargando..."),
                                            builder: (context, snapshot) {
                                              var profile = snapshot.data;
                                              if (profile == null) {
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("No hay datos",
                                                        style:
                                                            subtitleStyleText(
                                                                "", 14)),
                                                    Text("No hay datos",
                                                        style:
                                                            subtitleStyleText(
                                                                "", 18)),
                                                    const SizedBox(height: 3.1)
                                                  ],
                                                );
                                              }
                                              return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(height: 2),
                                                    Row(children: [
                                                      Text(
                                                          profile.businessName ??
                                                              "",
                                                          style: titleStyleText(
                                                              "", 14),
                                                          textAlign:
                                                              TextAlign.left),
                                                    ]),
                                                    const SizedBox(height: 4),
                                                    Text(profile.idDoc ?? "",
                                                        style:
                                                            subtitleStyleText(
                                                                "", 14)),
                                                    const SizedBox(height: 2),
                                                    _device != null
                                                        ? Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                          )
                                                        : const SizedBox()
                                                  ]);
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  transform:
                                      Matrix4.translationValues(5, -17.5, 0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Image(
                                        image: AssetImage(
                                            "${appTheme.assetsImg.uri}${appTheme.assetsImg.logo2}"),
                                        width: 50,
                                        height: 50),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      StickyHeader(
                        header: Padding(
                          padding: const EdgeInsets.only(
                              left: 0, bottom: 10, right: 0, top: 0),
                          child: Row(
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      // ignore: deprecated_member_use_from_same_package
                                      backgroundColor: pageSelected == "pos"
                                          ? ColorUtil.primary
                                          : ColorUtil.gray,
                                      elevation: 2,
                                      minimumSize: Size(screenWidth * 0.5, 20),
                                      shape: const BeveledRectangleBorder(
                                        borderRadius: BorderRadius.zero,
                                      )),
                                  onPressed: () {
                                    setState(() {
                                      pageSelected = "pos";
                                    });
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    child: Center(
                                      child: Text("POS"),
                                    ),
                                  )),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      // ignore: deprecated_member_use_from_same_package
                                      backgroundColor: pageSelected == "recarga"
                                          ? ColorUtil.primary
                                          : ColorUtil.gray,
                                      elevation: 2,
                                      minimumSize: Size(screenWidth * 0.5, 20),
                                      shape: const BeveledRectangleBorder(
                                        borderRadius: BorderRadius.zero,
                                      )),
                                  onPressed: () {
                                    setState(() {
                                      pageSelected = "recarga";
                                    });
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    child: Center(
                                      child: Text("Pago de Servicios"),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        content: pageSelected == "pos"
                            ? !getNotNullRoles("pinpagos")
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 50.0),
                                        child: Column(
                                          children: [
                                            Center(
                                              child: Lottie.asset(
                                                  "assets/img/transaction-failed.json",
                                                  repeat: false,
                                                  width: 100,
                                                  height: 100),
                                            ),
                                            const SizedBox(height: 20),
                                            const Text(
                                                "No posees el Rol para utilizar esta App",
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.red)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : state is! BluetoothDeviceConnectedState
                                    ? connecteBT()
                                    : state is BluetoothDisconnectState
                                        ? connecteBT()
                                        : Column(
                                            children: [
                                              const SizedBox(height: 10),
                                              PosWidget(
                                                  bloc: PosEqBloc(),
                                                  appTheme: appTheme),
                                              const SizedBox(height: 10),
                                            ],
                                          )
                            : !getNotNullRoles("servicepay")
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 50.0),
                                        child: Column(
                                          children: [
                                            Center(
                                              child: Lottie.asset(
                                                  "assets/img/transaction-failed.json",
                                                  repeat: false,
                                                  width: 100,
                                                  height: 100),
                                            ),
                                            const SizedBox(height: 20),
                                            const Text(
                                                "No posees el Rol para utilizar esta App",
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.red)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      SalesWidget(bloc: SalesEqBloc()),
                                    ],
                                  ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ));
        });
  }
}
