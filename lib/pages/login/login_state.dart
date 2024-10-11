part of 'login_bloc.dart';

@immutable
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitialState extends LoginState {
  const LoginInitialState();
}

class LoginLoadingState extends LoginState {
  const LoginLoadingState();
}

class LoginErrorState extends LoginState {
  final String errorMessage;

  const LoginErrorState({
    required this.errorMessage,
  });
}

class GoToAuthDeviceState extends LoginState {
  const GoToAuthDeviceState();
}

class LoginSuccessState extends LoginState {
  const LoginSuccessState();
}
