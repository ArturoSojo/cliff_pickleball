import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:cliff_pickleball/pages/abstracts/base_page.dart';
import 'package:cliff_pickleball/pages/logout/logout_bloc.dart';
import 'package:cliff_pickleball/styles/bg.dart';
import 'package:cliff_pickleball/styles/text.dart';
import 'package:cliff_pickleball/utils/staticNamesRoutes.dart';

import '../../domain/device.dart';
import '../../services/cacheService.dart';

class LogoutScreen extends BasePage {
  LogoutScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends BaseState<LogoutScreen> with BasicPage {
  final _logger = Logger();

  Device? device;

  final _cache = Cache();

  Widget buttonText =
      Text("CERRAR SESIÓN", style: subtitleStyleText("white", 15));

  @override
  void initState() {
    _bloc().add(const InitEvent());
    super.initState();
    getMerchant();
  }

  void executeLogoutEvent() {
    _bloc().add(const ExecuteLogoutEvent());
  }

  void getMerchant() async {
    var deviceResponse = await _cache.getMerchantDeviceResponse();
    device = deviceResponse?.device;
  }

  void closeSession() {
    setState(() {
      buttonText = const SizedBox(
        width: 25,
        height: 25,
        child: CircularProgressIndicator(color: ColorUtil.white),
      );
    });
    executeLogoutEvent();
  }

  @override
  Widget rootWidget(BuildContext context) {
    return BlocConsumer<LogoutBloc, LogoutState>(
      bloc: _bloc(),
      listener: (context, state) {
        if (state is GotoLoginState) {
          _logger.i("Going to login");
          context.go(StaticNames.loginName.path);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(
              "CERRAR SESIÓN",
              style: titleStyleText("white", 18),
            ),
            centerTitle: true,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                    padding: EdgeInsets.all(10),
                    child: Image(
                        image: AssetImage("assets/img/pos.png"),
                        height: 100,
                        width: 100)),
                device != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Card(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  child: Center(
                                      child: Text(
                                          "COMERCIO: ${device?.commerceName}",
                                          style:
                                              subtitleStyleText("gray", 16))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  child: Center(
                                      child: Text(
                                          "RIF: ${device?.commerceIdDoc}",
                                          style:
                                              subtitleStyleText("gray", 16))),
                                ),
                              ]),
                        ),
                      )
                    : Row(),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            margin: const EdgeInsets.fromLTRB(1, 15, 4, 5),
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: ColorUtil.error,
                                    padding: const EdgeInsets.all(20)),
                                onPressed: closeSession,
                                child: buttonText
                                /*onPressed: () => setState(() {
                                  generateModal();
                                })*/
                                ))),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  LogoutBloc _bloc() {
    return context.read<LogoutBloc>();
  }
}
