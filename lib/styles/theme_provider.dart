import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:cliff_pickleball/styles/theme_holder.dart';

import 'color_provider/color_provider.dart';
import 'domain/app_theme.dart';

@singleton
class ThemeProvider extends ChangeNotifier {
  final _logger = Logger();
  var _disposed = false;
  final ThemeHolder _holder;

  ThemeProvider(this._holder) {
    _load();
  }

  HashMap<String, AppTheme> get themes => _holder.themes;

  Future<void> loadThemes() async {
    return _holder.loadThemes();
  }

  _load() {
    _holder.load();
    notifyListeners();
  }

  Future<void> setDfltTheme() async {
    await _holder.setDfltTheme();
    notifyListeners();
  }

  Future<void> changeTheme(String str) async {
    await _holder.changeTheme(str);
    notifyListeners();
  }

  ThemeData theme() {
    return _holder.theme();
  }

  AppTheme appTheme() {
    return _holder.appTheme();
  }

  ColorProvider colorProvider() {
    return _holder.colorProvider();
  }

  @override
  void dispose() {
    _logger.i("DISPOSE_THEME_PROVIDER");
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    } else {
      _logger.i("THEME_PROVIDER_IS_DISPOSED");
    }
  }
}
