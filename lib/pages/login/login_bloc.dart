import 'dart:async';
import 'dart:ffi';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:optional/optional.dart';
import 'package:cliff_pickleball/domain/rolesModel.dart';
import 'package:cliff_pickleball/pages/login/login_service.dart';
import 'package:cliff_pickleball/services/http/result.dart';
import 'package:rxdart/rxdart.dart';

import '../../di/injection.dart';
import '../../services/cacheService.dart';
import '../../services/http/api_services.dart';
import '../../services/token_service.dart';
import '../../utils/utils.dart';
import 'login_event.dart';

part 'login_state.dart';

@injectable
class LoginScreenBloc extends Bloc<LoginEvent, LoginState> {
  LoginScreenBloc(this._loginService, this._cache)
      : super(const LoginInitialState()) {
    on<LoginEvent>((event, emitter) async {
      switch (event.runtimeType) {
        case InitEvent:
          clearStreams();
          emitter(const LoginInitialState());
          break;
        case LoginTryEvent:
          await _onLoginTryEvent(emitter);
          break;
      }
    });
  }

  final _logger = Logger();
  final LoginService _loginService;
  final Cache _cache;

  final _userNameController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  Stream<String> get userNameStream => _userNameController.stream;

  Stream<String> get passwordStream => _passwordController.stream;

  void clearStreams() {
    updateUserName('');
    updatePassword('');
  }

  Future<void> _onLoginTryEvent(Emitter<LoginState> emitter) async {
    emitter(const LoginLoadingState());

    var result = await _login();

    var errorMessage = Optional.ofNullable(result.msg)
        .map((p0) => p0.message)
        .orElse(result.errorMessage ?? "Error al loguearse");

    if (result.success) {
      if (errorMessage == "AUTHORIZATION_EMAIL_SENDED") {
        emitter(const GoToAuthDeviceState());
      } else {
        //await _loginService.saveProfile();
        //emitter(const LoginSuccessState());
        var resServicepay = await _loginService.getRole("servicepay");
        var resPinpagos = await _loginService.getRole("pinpagos");
        if (resServicepay.success || resPinpagos.success) {
          RolesModel rolesConfirmed = RolesModel(
              resServicepay.success ? true : false,
              resPinpagos.success ? true : false);
          await _loginService.saveRoles(rolesConfirmed);
          await _loginService.saveProfile();
          emitter(const LoginSuccessState());
        } else {
          await getIt<TokenService>()
              .token()
              .then((value) => value.obj)
              .then((value) => getIt<ApiServices>().closeSession(value!));
          var errorMessage = resServicepay.errorMessage ??
              resPinpagos.errorMessage ??
              "Error al loguearse";
          _logger.i(errorMessage);
          emitter(LoginErrorState(errorMessage: errorMessage));
        }
      }
    } else {
      if (errorMessage == "AUTHORIZATION_EMAIL_SENDED") {
        emitter(const GoToAuthDeviceState());
      } else {
        var errorMessage = result.errorMessage ?? "Error al loguearse";
        emitter(LoginErrorState(errorMessage: errorMessage));
      }
    }
  }

  void clear() {
    _userNameController.value = "";
    _passwordController.value = "";
  }

  void updateUserName(String value) {
    var result = _validateUserName(value);
    if (result != null) {
      _userNameController.sink.addError(result);
    } else {
      _userNameController.sink.add(value);
    }
  }

  void updatePassword(String value) {
    var result = _validatePassword(value);
    if (result != null) {
      _passwordController.sink.addError(result);
    } else {
      _passwordController.sink.add(value);
    }
  }

  String? _validateUserName(String? value) {
    if (value == null || value == "") {
      return "El correo electrónico no puede estar vacío";
    }

    if (!MyUtils.REX_EMAIL.hasMatch(value)) {
      return "Ingresa un correo electrónico válido";
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value == "") {
      return "La contraseña no puede estar vacía";
    }

    return null;
  }

  Stream<bool> get validateForm => Rx.combineLatest2(
        userNameStream.map((event) => _validateUserName(event) == null),
        passwordStream.map((event) => _validatePassword(event) == null),
        (
          a,
          b,
        ) =>
            a && b,
      );

  Future<Result<Void>> _login() async {
    var retries = 0;
    return RetryWhenStream(
        () => Rx.combineLatest2(userNameStream, passwordStream,
                (userName, password) {
              return _loginService.passwordGrant(userName, password).asStream();
            }).flatMap((value) => value), (error, stackTrace) {
      retries += 1;
      if (retries < 5) {
        return Stream.value("");
      } else {
        return Stream.error(error, stackTrace);
      }
    }).first.onError(Result.fail);

    /* return Rx.combineLatest2(userNameStream, passwordStream,
        (userName, password) {
      return _loginService
          .passwordGrant(userName, password)
          .onError((error, stackTrace) => Result.fail(error, stackTrace))
          .asStream();
    }).flatMap((value) => value).first;*/
  }
}
