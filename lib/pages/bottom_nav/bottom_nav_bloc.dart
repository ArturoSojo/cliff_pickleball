import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_plugin_qpos/QPOSModel.dart';
import 'package:flutter_plugin_qpos/flutter_plugin_qpos.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:cliff_pickleball/services/cacheService.dart';

part 'bottom_nav_event.dart';
part 'bottom_nav_state.dart';

@injectable
class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  final _logger = Logger();
  final _flutterPluginQpos = FlutterPluginQpos();

  final Cache _cache;

  StreamSubscription<QPOSModel>? _subscription;

  BottomNavBloc(this._cache) : super(BottomNavInitial()) {
    on<BottomNavEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  void init() {
    /* _subscription?.cancel();
    _subscription =
        _flutterPluginQpos.onPosListenerCalled!.listen(_solveQPOSModel);*/
  }

  @override
  Future<void> close() {
    // _subscription?.cancel();
    return super.close();
  }

  void _clearDevice() {
    _cache.deleteQposData();
  }

  void disconnectDevice() async {
    try {
      _clearDevice();
      await _flutterPluginQpos.disconnectBT();
    } catch (err) {
      _logger.e("DISCONNECT_TO_DEVICE", err);
    }
  }
}
