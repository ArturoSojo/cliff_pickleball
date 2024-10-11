import 'package:flutter/widgets.dart';

@immutable
abstract class LoginEvent {
  const LoginEvent();
}

class LoginTryEvent extends LoginEvent {

  const LoginTryEvent();
}
class InitEvent extends LoginEvent {

  const InitEvent();
}
