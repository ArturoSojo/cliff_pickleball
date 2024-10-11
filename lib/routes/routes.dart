import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:cliff_pickleball/pages/anulated_result.dart';
import 'package:cliff_pickleball/pages/auth_device/auth_device_bloc.dart';
import 'package:cliff_pickleball/pages/auth_device/auth_device_screen.dart';
import 'package:cliff_pickleball/pages/bluetooth/bluetooth_scan_screen.dart';
import 'package:cliff_pickleball/pages/bottom_nav/bottom_nav.dart';
import 'package:cliff_pickleball/pages/bottom_nav/bottom_nav_bloc.dart';
import 'package:cliff_pickleball/pages/cancel_payment/domain/operation.dart';
import 'package:cliff_pickleball/pages/closed.dart';
import 'package:cliff_pickleball/pages/details/bloc/details_bloc.dart';
import 'package:cliff_pickleball/pages/details_report.dart';
import 'package:cliff_pickleball/pages/home.dart';
import 'package:cliff_pickleball/pages/last/last_report.dart';
import 'package:cliff_pickleball/pages/login/login_screen.dart';
import 'package:cliff_pickleball/pages/logout/logout_screen.dart';
import 'package:cliff_pickleball/pages/new_sale/view/new_sale_screen.dart';
import 'package:cliff_pickleball/pages/simple_and_total/simple_report.dart';
import 'package:cliff_pickleball/pages/test/echo_test.dart';
import 'package:cliff_pickleball/pages/transactions/transactions_screen.dart';
import 'package:cliff_pickleball/utils/global.dart';
import 'package:cliff_pickleball/utils/staticNamesRoutes.dart';
import 'package:cliff_pickleball/utils/utils.dart';
import 'package:cliff_pickleball/widgets/transaction_receipt.dart';

import '../di/injection.dart';
import '../pages/cancel_payment/cancel_payment_screen.dart';
import '../pages/details/details_screen.dart';
import '../pages/product/product.dart';
import '../pages/product_card/product_card_screen.dart';
import '../pages/recharge/bloc/recharge_bloc.dart';
import '../pages/recharge/recharge.dart';
import '../pages/store/bloc/store_bloc.dart';
import '../pages/store/models/store_model.dart';
import '../pages/store/store_screen.dart';
import '../services/cacheService.dart';
import '../services/http/domain/productModel.dart';
import '../widgets/splash_screen.dart';

final _rootNavigatorKey = Globalkeys.rootNavigatorKey;
final _shellNavigatorKey = Globalkeys.shellNavigatorKey;

final _logger = Logger();

class Routes extends StatefulWidget {
  const Routes({Key? key}) : super(key: key);

  @override
  State<Routes> createState() => _RoutesState();
}

class _RoutesState extends State<Routes> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      locale: const Locale('es'),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}

GoRoute rootRoute() {
  if (MyUtils.showSplashScreen) {
    return GoRoute(
        path: StaticNames.rootName.path,
        builder: (context, state) {
          _logger.i(state.uri.toString());
          return SplashScreen();
        });
  }

  return GoRoute(
      path: StaticNames.rootName.path,
      redirect: (context, state) async {
        bool isLoggedIn = await getIt<Cache>().areCredentialsStored();
        _logger.i("tienes credenciales? $isLoggedIn");
        return isLoggedIn
            ? StaticNames.homeName.path
            : StaticNames.loginName.path;
      });
}

final GoRouter router = GoRouter(
  initialLocation: StaticNames.rootName.path,
  navigatorKey: _rootNavigatorKey,
  routes: [
    rootRoute(),
    GoRoute(
        path: StaticNames.loginName.path,
        name: StaticNames.loginName.name,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          _logger.i(state.uri.toString());
          return const LoginScreen();
        }),
    GoRoute(
      path: StaticNames.authDeviceName.path,
      name: StaticNames.authDeviceName.name,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        _logger.i(state.uri.toString());
        return AuthDeviceScreen(bloc: getIt<AuthDeviceBloc>());
      },
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return BottomNavScreen(bloc: getIt<BottomNavBloc>(), child: child);
      },
      routes: [
        GoRoute(
          parentNavigatorKey: _shellNavigatorKey,
          path: StaticNames.logoutName.path,
          name: StaticNames.logoutName.name,
          builder: (context, state) {
            _logger.i(state.uri.toString());

            return LogoutScreen();
          },
        ),
        GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            name: StaticNames.homeName.name,
            path: StaticNames.homeName.path,
            builder: (context, state) {
              _logger.i(state.uri.toString());
              return HomePage();
            },
            routes: [
              GoRoute(
                parentNavigatorKey: _shellNavigatorKey,
                name: StaticNames.newSales.name,
                path: StaticNames.newSales.path,
                builder: (context, state) {
                  _logger.i(state.uri.toString());
                  return const NewSaleScreen();
                },
                /*  routes: [
                GoRoute(
                      name: StaticNames.dni.name,
                      path: '${StaticNames.dni.path}:amount',
                      builder: (context, state) {
                        _logger.i(state.uri.toString());
                        return KeyboardDni(amount: state.params['amount']!);
                      },
                      routes: [
                        GoRoute(
                            parentNavigatorKey: _shellNavigatorKey,
                            path: '${StaticNames.cardName.path}:dni',
                            name: StaticNames.cardName.name,
                            builder: (context, state) {
                              _logger.i(state.uri.toString());
                              return PaymentCard(
                                  dni: state.params["dni"]!,
                                  amount: state.params["amount"]!);
                            },
                            routes: [
                              GoRoute(
                                  parentNavigatorKey: _shellNavigatorKey,
                                  path: StaticNames.typeAccountName.path,
                                  name: StaticNames.typeAccountName.name,
                                  builder: (context, state) {
                                    _logger.i(state.uri.toString());
                                    Map<String, dynamic> data =
                                        state.extra as Map<String, dynamic>;
                                    return TypeAccount(data: data);
                                  },
                                  routes: [
                                    GoRoute(
                                        parentNavigatorKey:
                                            _shellNavigatorKey,
                                        path: StaticNames.pinName.path,
                                        name: StaticNames.pinName.name,
                                        builder: (context, state) {
                                          _logger.i(state.uri.toString());
                                          Map<String, dynamic> data = state
                                              .extra as Map<String, dynamic>;
                                          return KeyboardPin(data: data);
                                        },
                                        routes: [
                                          GoRoute(
                                            parentNavigatorKey:
                                                _shellNavigatorKey,
                                            path: StaticNames
                                                .newSalesResultPin.path,
                                            name: StaticNames
                                                .newSalesResultPin.name,
                                            builder: (context, state) {
                                              _logger.i(state.uri.toString());
                                              Map<String, dynamic> data =
                                                  state.extra
                                                      as Map<String, dynamic>;
                                              return TrasactionResult(
                                                  data: data);
                                            },
                                          ),
                                        ]),
                                    GoRoute(
                                      parentNavigatorKey: _shellNavigatorKey,
                                      path: StaticNames.newSalesResult.path,
                                      name: StaticNames.newSalesResult.name,
                                      builder: (context, state) {
                                        _logger.i(state.uri.toString());
                                        Map<String, dynamic> data = state
                                            .extra as Map<String, dynamic>;
                                        return TrasactionResult(data: data);
                                      },
                                    ),
                                  ]),
                            ]),
                      ]),
                ]*/
              ),
              GoRoute(
                  name: StaticNames.transactionsName.name,
                  path: StaticNames.transactionsName.name,
                  builder: (context, state) {
                    _logger.i(state.uri.toString());

                    return Transactions();
                  },
                  routes: [
                    GoRoute(
                      parentNavigatorKey: _shellNavigatorKey,
                      path: StaticNames.transactionViewName.path,
                      name: StaticNames.transactionViewName.name,
                      builder: (context, state) {
                        _logger.i(state.uri.toString());
                        Map<String, dynamic> data =
                            state.extra as Map<String, dynamic>;
                        return TransactionReceipt(data: data);
                      },
                    ),
                    GoRoute(
                      parentNavigatorKey: _shellNavigatorKey,
                      path: StaticNames.AnulateName.path,
                      name: StaticNames.AnulateName.name,
                      builder: (context, state) {
                        _logger.i(state.uri.toString());

                        return CancelPaymentScreen(Operation.fromJson(
                            jsonDecode(jsonEncode(state.extra))));
                      },
                    ),
                    GoRoute(
                      parentNavigatorKey: _shellNavigatorKey,
                      path: StaticNames.AnulateResultName.path,
                      name: StaticNames.AnulateResultName.name,
                      builder: (context, state) {
                        _logger.i(state.uri.toString());
                        Map<String, dynamic> data =
                            state.extra as Map<String, dynamic>;
                        return AnulatedResult(data: data);
                      },
                    ),
                  ]),
              GoRoute(
                parentNavigatorKey: _shellNavigatorKey,
                path: StaticNames.totalName.path,
                name: StaticNames.totalName.name,
                builder: (context, state) {
                  _logger.i(state.uri.toString());
                  return SimpleReport(title: "REPORTE TOTAL", total: true);
                },
              ),
              GoRoute(
                parentNavigatorKey: _shellNavigatorKey,
                path: StaticNames.simpleName.path,
                name: StaticNames.simpleName.name,
                builder: (context, state) {
                  _logger.i(state.uri.toString());
                  return SimpleReport(title: "REPORTE SIMPLE", total: false);
                },
              ),
              GoRoute(
                parentNavigatorKey: _shellNavigatorKey,
                path: StaticNames.lastName.path,
                name: StaticNames.lastName.name,
                builder: (context, state) {
                  _logger.i(state.uri.toString());
                  return LastReport();
                },
              ),
              GoRoute(
                parentNavigatorKey: _shellNavigatorKey,
                path: StaticNames.detailsName.path,
                name: StaticNames.detailsName.name,
                builder: (context, state) {
                  _logger.i(state.uri.toString());
                  return DetailsReport();
                },
              ),
              GoRoute(
                parentNavigatorKey: _shellNavigatorKey,
                path: StaticNames.testName.path,
                name: StaticNames.testName.name,
                builder: (context, state) {
                  _logger.i(state.uri.toString());
                  return EchoTestScreen();
                },
              ),
              GoRoute(
                parentNavigatorKey: _shellNavigatorKey,
                name: StaticNames.product.name,
                path: StaticNames.product.path,
                builder: (context, state) {
                  _logger.i(state.uri.toString());
                  var product = state.extra as ProductModel;
                  _logger.i(product.formattedName);
                  return NewSalesProduct(product: product);
                },
                /* routes: [
                GoRoute(
                  parentNavigatorKey: _shellNavigatorKey,
                  name: StaticNames.product_card.name,
                  path: StaticNames.product_card.path,
                  builder: (context, state) {
                    _logger.i(state.uri.toString());
                    var product = state.extra as ProductModel;
                    _logger.i(product.formattedName); // AQUI EL PRODUCT CARD
                    return ProductCardRecharge(product: product);
                  },
                ),
              ] */
              ),
              GoRoute(
                parentNavigatorKey: _shellNavigatorKey,
                path: StaticNames.closeName.path,
                name: StaticNames.closeName.name,
                builder: (context, state) {
                  _logger.i(state.uri.toString());
                  return Closed();
                },
              ),
            ]),
        GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            path: StaticNames.bluetoothName.path,
            name: StaticNames.bluetoothName.name,
            builder: (context, state) {
              _logger.i(state.uri.toString());

              return BluetoothScanScreen(
                  //bloc: getIt<BluetoothScanBloc>(),
                  );
            }),
        GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            path: StaticNames.store.path,
            name: StaticNames.store.name,
            builder: (context, state) {
              _logger.i(state.uri.toString());
              return StoreScreen(bloc: StoreBloc());
            },
            routes: [
              GoRoute(
                name: StaticNames.detailsStore.name,
                parentNavigatorKey: _shellNavigatorKey,
                path: StaticNames.detailsStore.path,
                builder: (context, state) {
                  _logger.i(state.uri.toString());
                  var product = state.extra as Results;
                  return DetailsScreen(
                    bloc: DetailsBloc(product: product),
                  );
                },
              ),
              GoRoute(
                name: StaticNames.recharge.name,
                parentNavigatorKey: _shellNavigatorKey,
                path: StaticNames.recharge.path,
                builder: (context, state) {
                  _logger.i(state.uri.toString());
                  var list = state.extra as List<String>;
                  _logger.i(list);

                  return RechageScreen(bloc: RechargeBloc(listTypes: list));
                },
              )
            ]),
      ],
    ),
  ],
);
