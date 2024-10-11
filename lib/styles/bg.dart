import 'package:flutter/material.dart';
import 'package:cliff_pickleball/styles/theme_provider.dart';

import '../di/injection.dart';

class ColorUtil {
// This class is not meant to be instantiated or extended; this constructor
  // prevents instantiation and extension.
  ColorUtil._();

  @Deprecated("")
  static const Color primary = Color(0xFF4A148C);
  static const Color success = Color.fromARGB(255, 82, 255, 143);
  static const Color white = Color.fromARGB(255, 255, 255, 255);
  static const Color gray = Color.fromARGB(255, 197, 197, 197);
  static const Color dark_gray = Color.fromARGB(255, 94, 91, 91);
  static const Color lightGray = Color.fromARGB(255, 240, 239, 239);
  static const Color black = Color.fromARGB(255, 65, 65, 65);
  static const Color secondary = Color.fromARGB(248, 249, 243, 254);
  static const Color grayLight = Color.fromARGB(255, 242, 243, 245);
  static const Color error = Color.fromARGB(255, 228, 52, 46);
  static const Color warning = Color.fromARGB(255, 255, 251, 9);

  static Color primaryColor() {
    return getIt<ThemeProvider>().colorProvider().primary();
  }

  static Color primaryLightColor() {
    return getIt<ThemeProvider>().colorProvider().primaryLight();
  }
}
