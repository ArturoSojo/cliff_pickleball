import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_plugin_qpos/flutter_plugin_qpos.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:cliff_pickleball/pages/logout/logout_service.dart';
import 'package:cliff_pickleball/services/cacheService.dart';

import '../../styles/theme_provider.dart';

part 'logout_event.dart';
part 'logout_state.dart';

@injectable
class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final _logger = Logger();
  final LogoutService _logoutService;
  final ThemeProvider themeProvider;
  final Cache _cache;

  final _flutterPluginQpos = FlutterPluginQpos();

  LogoutBloc(this._logoutService, this._cache, this.themeProvider)
      : super(const LogoutInitial()) {
    on<LogoutEvent>((event, emit) async {
      switch (event.runtimeType) {
        case InitEvent:
          emit(const LogoutInitial());
          break;
        case ExecuteLogoutEvent:
          _logger.i("CLOSE SESSION");
          await themeProvider.setDfltTheme();

          unawaited(_flutterPluginQpos
              .disconnectBT()
              .onError((error, stackTrace) => null));
          unawaited(_logoutService.closeSession());

          Timer(const Duration(seconds: 3), () async {
            _logger.i("DELETING_DATA");
            await _cache.deleteAccessToken();
            await _cache.emptyCacheData();
          });

          _logger.i("GotoLoginState");
          emit(const GotoLoginState());
          break;
      }
    });
  }
}
