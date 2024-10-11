part of 'routes_bloc.dart';

@immutable
abstract class RoutesState {
  bool isBluetoothEnabled = false;
  RoutesState({required isBluetoothEnabled});
}

class RoutesInitialState extends RoutesState {
  RoutesInitialState({super.isBluetoothEnabled});
}

class RoutesBluetoothOnState extends RoutesState {
  RoutesBluetoothOnState({super.isBluetoothEnabled});
}


