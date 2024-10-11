import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'app_drawer_event.dart';
part 'app_drawer_state.dart';

class AppDrawerBloc extends Bloc<AppDrawerEvent, AppDrawerState> {
  AppDrawerBloc() : super(const AppDrawerInitial()) {
    on<AppDrawerEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
