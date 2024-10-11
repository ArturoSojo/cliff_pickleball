import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:cliff_pickleball/styles/theme_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/utils.dart';
import 'color_provider/color_provider.dart';
import 'color_provider/color_provider_impl.dart';
import 'color_provider/pinpagos_color_provider.dart';
import 'decorations_style.dart';
import 'domain/app_theme.dart';

@singleton
class ThemeHolder {
  final _logger = Logger();
  final String _key = "theme";
  static const String _defaultKey = "default";
  String _currentTheme = _defaultKey;

  final HashMap<String, ColorProvider> _colorProviders = HashMap();
  final HashMap<String, AppTheme> _themes = HashMap();

  final ThemeLoader _themeLoader;

  ThemeHolder(this._themeLoader);

  HashMap<String, AppTheme> get themes => _themes;

  Future<void> loadThemes() async {
    var list = await _themeLoader.loadThemes();

    for (var theme in list) {
      var colorProvider = ColorProviderImpl(
          Color(int.parse(theme.colors.primary)),
          Color(int.parse(theme.colors.primaryLight)));

      _colorProviders.putIfAbsent(theme.name, () => colorProvider);
      _themes.putIfAbsent(theme.name, () => theme);

      if (theme.dflt) {
        _themes.putIfAbsent(_defaultKey, () => theme);
        _colorProviders.putIfAbsent(_defaultKey, () => colorProvider);
      }
    }
  }

  void load() async {
    var shPrefs = await _prefs();
    _currentTheme = shPrefs.getString(_key) ?? _defaultKey;
  }

  Future<void> setDfltTheme() {
    return changeTheme(_defaultKey);
  }

  void printCurrentTheme() {
    _logger.i("current_theme $_currentTheme");
  }

  Future<void> changeTheme(String str) async {
    _logger.i("changing theme $str");
    var shPrefs = await _prefs();
    _currentTheme = str;
    await shPrefs.setString(_key, str);
  }

  Future<SharedPreferences> _prefs() {
    return MyUtils.prefs();
  }

  ThemeData theme() {
    return MyTheme().theme(colorProvider());
  }

  AppTheme appTheme() {
    var theme = _themes[_currentTheme];

    if (theme == null) {
      throw Exception("themes is null");
    }

    return theme;
  }

  ColorProvider colorProvider() {
    //printCurrentTheme();
    return _colorProviders[_currentTheme] ?? PinPagosColorProvider();
  }
}
