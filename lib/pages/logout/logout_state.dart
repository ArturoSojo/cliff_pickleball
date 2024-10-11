part of 'logout_bloc.dart';

abstract class LogoutState extends Equatable {
  const LogoutState();

  @override
  List<Object> get props => [];
}

class LogoutInitial extends LogoutState {
  const LogoutInitial();
}

class GotoLoginState extends LogoutState {
  const GotoLoginState();
}
