part of 'auth_device_bloc.dart';

@immutable
abstract class AuthDeviceState extends Equatable {
  const AuthDeviceState();

  @override
  List<Object?> get props => [];
}

class AuthDeviceInitialState extends AuthDeviceState {
  const AuthDeviceInitialState();
}

class AuthDeviceLoadingState extends AuthDeviceState {
  const AuthDeviceLoadingState();
}

class AuthDeviceErrorState extends AuthDeviceState {
  final String errorMessage;

  const AuthDeviceErrorState({
    required this.errorMessage,
  });
}

class CodeSentState extends AuthDeviceState {
  const CodeSentState();
}

class CodeSentErrorState extends AuthDeviceState {
  final String errorMessage;

  const CodeSentErrorState({
    required this.errorMessage,
  });
}

class AuthDeviceSuccessState extends AuthDeviceState {
  const AuthDeviceSuccessState();
}
