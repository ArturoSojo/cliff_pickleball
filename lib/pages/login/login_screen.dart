import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:cliff_pickleball/services/cacheService.dart';
import 'package:cliff_pickleball/widgets/alert_dialog.dart';

import '../../di/injection.dart';
import '../../styles/bg.dart';
import '../../styles/text.dart';
import '../../utils/staticNamesRoutes.dart';
import 'login_bloc.dart';
import 'login_event.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _logger = Logger();

  var obscure = true;

  @override
  void initState() {
    _init();
    _logger.i("init");
    super.initState();
  }

  void _init() {
    _bloc().add(const InitEvent());
  }

  Future<String> check() async {
    var cache = getIt<Cache>();
    var token = await cache.getAccessTokenResponse();
    var profile = await cache.getProfile();
    var third =
        profile == null ? false : await cache.isDeviceAuthorized(profile.id!);

    return "is device auth $third token ${token?.accessToken})";
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          final value = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                actions: <Widget>[
                  TextButton(
                      child: const Text("SÍ"),
                      onPressed: () => SystemNavigator.pop()),
                  TextButton(
                      child: const Text("NO"),
                      onPressed: () => Navigator.of(context).pop())
                ],
                title: const Text("¿Seguro que deseas salir de la aplicación?"),
              );
            },
          );
          if (value != null) {
            return Future.value(value);
          } else {
            return Future.value(false);
          }
        },
        child: Scaffold(
            //resizeToAvoidBottomInset: false,
            body: SafeArea(
                child: Center(
                    child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: _formWidget()),
        )))));
  }

  void showToast(BuildContext context, String data) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data)));
  }

  Widget _formWidget() {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("BIENVENIDO A PINPAGOS MÓVIL",
              style: titleStyleText("primary", 18)),
          const SizedBox(
            height: 5,
          ),
          Text("Ahora puedes realizar transacciones desde tu smartphone",
              style: subtitleStyleText("", 18), textAlign: TextAlign.center),
          const Image(
            image: AssetImage("assets/img/Logo-PinPagos-04.png"),
            width: 200,
            height: 200,
          ),
          const SizedBox(
            height: 35,
          ),
          BlocConsumer<LoginScreenBloc, LoginState>(
              bloc: _bloc(),
              listener: (context, state) {
                _logger.i("state_listener $state");
                if (state is LoginSuccessState) {
                  _goNext();
                }
                if (state is LoginErrorState) {
                  _showError(state.errorMessage);
                }

                if (state is GoToAuthDeviceState) {
                  _goToAuthDevice();
                }
              },
              builder: (context, state) {
                _logger.i("state_builder $state");
                var isLoggingIn =
                    state is LoginLoadingState || state is LoginSuccessState;

                return Column(
                  children: [
                    _userAndPass(isLoggingIn),
                    _loginButton(isLoggingIn),
                  ],
                );
              }),
          const SizedBox(height: 30),
          FutureBuilder(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                var packageInfo = snapshot.data;
                if (snapshot.connectionState != ConnectionState.done ||
                    packageInfo == null) {
                  return const SizedBox();
                }

                final appName = packageInfo.appName;
                final packageName = packageInfo.packageName;
                final version = packageInfo.version;
                final buildNumber = packageInfo.buildNumber;
                _logger.i(
                    "appName $appName packageName $packageName version $version buildNumber $buildNumber");
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("PINPAGOS $version", style: subtitleStyleText("", 16)),
                    const SizedBox(height: 5),
                    Text("UN PRODUCTO CREDICARD",
                        style: titleStyleText("primary", 14)),
                  ],
                );
              })
        ],
      ),
    );
  }

  LoginScreenBloc _bloc() {
    return context.read<LoginScreenBloc>();
  }

  Widget _userAndPass(bool isLoggingIn) {
    return AutofillGroup(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 10,
        ),
        StreamBuilder(
            stream: _bloc().userNameStream,
            builder: (context, snapshot) {
              return TextFormField(
                autofillHints: const [AutofillHints.email],
                keyboardType: TextInputType.emailAddress,
                maxLength: 100,
                readOnly: false,
                onChanged: (text) => _bloc().updateUserName(text),
                enabled: !isLoggingIn,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => snapshot.error?.toString(),
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    /*suffixIcon: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: _bloc().clear),*/
                    labelText: "Correo electrónico",
                    border: OutlineInputBorder(),
                    hintText: ''),
              );
            }),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder(
            stream: _bloc().passwordStream,
            builder: (context, snapshot) {
              return TextFormField(
                autofillHints: const [AutofillHints.password],
                keyboardType: TextInputType.text,
                maxLength: 20,
                readOnly: false,
                onChanged: (text) => _bloc().updatePassword(text),
                enabled: !isLoggingIn,
                validator: (value) => snapshot.error?.toString(),
                obscureText: obscure,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline_sharp),
                    suffixIcon: IconButton(
                        icon: Icon(
                            obscure ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() {
                              obscure = !obscure;
                            })),
                    labelText: "Contraseña",
                    border: const OutlineInputBorder()),
              );
            }),
        const SizedBox(
          height: 10,
        ),
      ],
    ));
  }

  Widget _loginButton(bool isLoggingIn) {
    return StreamBuilder(
        stream: _bloc().validateForm,
        builder: (context, snapshot) {
          return Row(
            children: [
              Expanded(
                  child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                      child:
                          _textButton((snapshot.data ?? false), isLoggingIn))),
            ],
          );
        });
  }

  Widget _textButton(bool formIsValid, bool isLoggingIn) {
    return TextButton(
        style: TextButton.styleFrom(
            backgroundColor:
                formIsValid ? ColorUtil.primaryColor() : Colors.grey,
            padding: const EdgeInsets.all(20)),
        onPressed: formIsValid && !isLoggingIn ? _loginBtnTap : null,
        child: _textOrProgress(isLoggingIn));
  }

  Widget _textOrProgress(bool isLoggingIn) {
    if (isLoggingIn) {
      return const CircularProgressIndicator(
        color: ColorUtil.white,
      );
    }

    return Text("INICIAR SESIÓN",
        selectionColor: ColorUtil.gray, style: subtitleStyleText("white", 15));
  }

  void _loginBtnTap() async {
    //var data = await check();
    //showToast(context, data);

    _bloc().add(const LoginTryEvent());
  }

  void _showError(String errorMsg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Alerts.error(errorMsg, () => Navigator.pop(context));
      },
    );
  }

  void _goNext() {
    // _sessionTimer.startTimer();flutter pub add flutter_blue_plus
    context.go(StaticNames.homeName.path);
  }

  void _goToAuthDevice() {
    context.go(StaticNames.authDeviceName.path);
  }
}
