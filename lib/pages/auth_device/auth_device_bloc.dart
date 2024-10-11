import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:cliff_pickleball/domain/message.dart';
import 'package:cliff_pickleball/pages/login/login_service.dart';
import 'package:rxdart/rxdart.dart';

import '../../services/http/result.dart';
import 'auth_device_event.dart';
import 'auth_device_service.dart';

part 'auth_device_state.dart';

@injectable
class AuthDeviceBloc extends Bloc<AuthDeviceEvent, AuthDeviceState> {
  final AuthDeviceService _authDeviceService;
  final LoginService _loginService;
  final _logger = Logger();
  final _codeController = BehaviorSubject<String>();
  final _nameController = BehaviorSubject<String>();

  Stream<String> get codeStream => _codeController.stream;

  Stream<String> get nameStream => _nameController.stream;

  AuthDeviceBloc(this._authDeviceService, this._loginService)
      : super(const AuthDeviceInitialState()) {
    on<AuthDeviceTryEvent>(_onAuthDeviceTryEvent);
    on<ResendCodeEvent>(_onResendCodeEvent);
  }

  void clear() {
    _codeController.sink.add("");
    _nameController.sink.add("");
  }

  Future<void> _onAuthDeviceTryEvent(
      AuthDeviceTryEvent event, Emitter<AuthDeviceState> emitter) async {
    emitter(const AuthDeviceLoadingState());

    _codeController.sink.add(event.authCode);
    var result = await _authDevice();
    if (result.success) {
      var resPinpagos = await _loginService.getRole("pinpagos");
      var resServicepay = await _loginService.getRole("pinpagos");
      if (resPinpagos.success || resServicepay.success) {
        await _loginService.saveProfile();
        emitter(const AuthDeviceSuccessState());
      } else {
        var errorMessage = resPinpagos.errorMessage ??
            resServicepay.errorMessage ??
            "Error al autorizar dispositivo";
        _logger.i(errorMessage);

        emitter(AuthDeviceErrorState(errorMessage: errorMessage));
      }
    } else {
      var errorMessage =
          result.errorMessage ?? "Error al autorizar dispositivo";
      emitter(AuthDeviceErrorState(errorMessage: errorMessage));
    }
  }

  Future<void> _onResendCodeEvent(
      ResendCodeEvent event, Emitter<AuthDeviceState> emitter) async {
    emitter(const AuthDeviceLoadingState());

    var result = await _authDeviceService.sendAuthDeviceCode();
    if (result.success) {
      emitter(const CodeSentState());
    } else {
      var errorMessage =
          result.errorMessage ?? "Error al enviar codigo de autorizacion";
      emitter(CodeSentErrorState(errorMessage: errorMessage));
    }
  }

  void updateCode(String value) {
    _codeController.sink.add(value);
    /* var result = _validateCode(value);
    if (result != null) {
      _codeController.sink.addError(result);
    } else {
      _codeController.sink.add(value);
    }*/
  }

  String? _validateCode(String? value) {
    if (value == null || value == "") {
      return "El codigo no puede estar vacio";
    }

    return null;
  }

  Stream<bool> get validateCode =>
      codeStream.map((event) => _validateCode(event) == null);

  Future<Result<Message>> _authDevice() async {
    return Rx.combineLatest2(codeStream, nameStream, (authCode, name) {
      return _authDeviceService
          .authDevice(authCode, name)
          .onError((error, stackTrace) => Result.fail(error, stackTrace))
          .asStream();
    }).flatMap((value) => value).first;
  }
}
