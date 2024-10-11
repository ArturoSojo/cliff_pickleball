part of 'logout_bloc.dart';

abstract class LogoutEvent extends Equatable {
  const LogoutEvent();

  @override
  List<Object> get props => [];
}

class ExecuteLogoutEvent extends LogoutEvent {
  const ExecuteLogoutEvent();
}


class InitEvent extends LogoutEvent {
  const InitEvent();
}