import 'dart:ui';

import 'color_provider.dart';

abstract class BaseColorProvider implements ColorProvider {
  static const Color _primary = Color(0xFF4A148C);
  static const Color _primaryLight = Color(0xFF8B34F6);

  @override
  Color primary() {
    return _primary;
  }

  @override
  Color primaryLight() {
    return _primaryLight;
  }
}
