abstract class AuthDeviceEvent {
  const AuthDeviceEvent();
}

class AuthDeviceTryEvent extends AuthDeviceEvent {
  final String authCode;

  const AuthDeviceTryEvent(this.authCode);
}

class ResendCodeEvent extends AuthDeviceEvent {}
