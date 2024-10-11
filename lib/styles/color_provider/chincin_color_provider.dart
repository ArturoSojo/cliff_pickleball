import 'dart:ui';

import 'base_color_provider.dart';

class ChinchinColorProvider extends BaseColorProvider {
  Color myPrimary;
  Color myPrimaryLight;

  ChinchinColorProvider({this.myPrimary = const Color(0xFF11A387), this.myPrimaryLight = const Color(0xFFA9EADD)});

  @override
  Color primary() {
    return myPrimary;
  }

  @override
  Color primaryLight() {
    return myPrimaryLight;
  }
}
