part of 'routes_bloc.dart';

@immutable
abstract class RoutesEvent {
  const RoutesEvent();
}

class RoutesInitialEvent extends RoutesEvent{
  RoutesInitialEvent();
}

class RoutesBluetoothOnEvent extends RoutesEvent{
  RoutesBluetoothOnEvent();
}


