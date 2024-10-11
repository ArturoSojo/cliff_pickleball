import 'dart:ui';

import 'base_color_provider.dart';

class PinPagosColorProvider extends BaseColorProvider {
  Color myPrimary;
  Color myPrimaryLight;

  PinPagosColorProvider({this.myPrimary = const Color(0xFF4A148C), this.myPrimaryLight = const Color(0xFF8B34F6)});

  @override
  Color primary() {
    return myPrimary;
  }

  @override
  Color primaryLight() {
    return myPrimaryLight;
  }
}