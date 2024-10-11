import 'dart:async';

import 'package:bloc/bloc.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';

part 'routes_event.dart';
part 'routes_state.dart';

class RoutesBloc extends Bloc<RoutesEvent, RoutesState> {
  bool _bluetoothState = false;
  // FlutterBluePlus _flutterBlue = FlutterBluePlus.instance;

  RoutesBloc() : super(RoutesInitialState(isBluetoothEnabled: false)) {
    on<RoutesEvent>((event, emit) {
        switch(event.runtimeType){
          case RoutesInitialEvent:
            emit(RoutesInitialState(isBluetoothEnabled: state.isBluetoothEnabled));
            _init();
          break;
          case RoutesBluetoothOnEvent:
            emit(RoutesInitialState(isBluetoothEnabled: _bluetoothState));
        }
    });
    _streamBluetooth();

  }

  Future<void> _init() async{
  }
  Future<void> requestBluetooth() async {
    // await _flutterBlue.turnOn();
  }
  Future<void> _streamBluetooth() async{
    // _flutterBlue.state.listen((event) {
    //   switch(event){
    //     case BluetoothState.on:
    //       print("estado del bluetooth ${true}");
    //       _bluetoothState = true;
    //       add(RoutesBluetoothOnEvent());
    //       break;
    //     case BluetoothState.off:
    //       print("estado del bluetooth ${false}");
    //       _bluetoothState = false;
    //       add(RoutesBluetoothOnEvent());
    //       break;
    //     case BluetoothState.unknown:
    //     case BluetoothState.unavailable:
    //       openAppSettings();
    //       break;
    //
    //     case BluetoothState.unauthorized:
    //       print("estado del bluetooth ${false}");
    //       _bluetoothState = false;
    //       add(RoutesBluetoothOnEvent());
    //       break;
    //
    //     case BluetoothState.turningOff:
    //       print("estado del bluetooth ${false}");
    //       _bluetoothState = false;
    //       add(RoutesBluetoothOnEvent());
    //       break;
    //   }
    // });
  }
}
