import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cliff_pickleball/styles/bg.dart';
import 'package:cliff_pickleball/styles/color_provider/color_provider.dart';
import 'package:cliff_pickleball/styles/text.dart';

const double _iconSize = 25;

class MyTheme {
  static const Color grayLight = Color.fromARGB(255, 242, 243, 245);
  static const Color gray = Color.fromARGB(255, 197, 197, 197);
  static const Color secondary = Color.fromARGB(248, 249, 243, 254);
  static const Color error = Color.fromARGB(255, 228, 52, 46);
  static const Color warning = Color.fromARGB(255, 255, 251, 9);
  static const Color labelColor = Color.fromARGB(255, 53, 53, 53);
  static String? fontFamily = GoogleFonts.roboto().fontFamily;

  ThemeData theme(ColorProvider colorProvider) {
    return ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: colorProvider.primary(),
          elevation: 0,
        ),
        textTheme: TextTheme(
          labelLarge: const TextStyle(color: labelColor, fontSize: 16),
          labelMedium: const TextStyle(color: labelColor, fontSize: 12),
          labelSmall: const TextStyle(color: labelColor, fontSize: 8),
          displayLarge:
              const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
          titleLarge:
              const TextStyle(fontSize: 30.0, fontStyle: FontStyle.normal),
          bodyMedium: TextStyle(fontSize: 18.0, fontFamily: fontFamily),
        ),
        iconTheme: IconThemeData(
          color: colorProvider.primaryLight(),
        ),
        iconButtonTheme: IconButtonThemeData(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(colorProvider.primary()),
                iconColor:
                    MaterialStateProperty.all(colorProvider.primaryLight()))),
        dialogTheme: DialogTheme(
          titleTextStyle: TitleTextStyle(
            color: ColorUtil.black,
            fontSize: 20,
            fontFamily: fontFamily,
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          height: 50,
          backgroundColor: colorProvider.primary(),
          surfaceTintColor: warning,
          elevation: 0,
          indicatorColor: colorProvider.primaryLight(),
          indicatorShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16))),
          labelTextStyle: MaterialStateTextStyle.resolveWith(
              (states) => const TextStyle(fontSize: 10, color: secondary)),
          iconTheme: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return const IconThemeData(color: secondary, size: _iconSize);
            }

            return const IconThemeData(color: gray, size: _iconSize);
          }),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        ),
        fontFamily: fontFamily,
        primaryColor: colorProvider.primary(),
        textSelectionTheme: TextSelectionThemeData(
            selectionColor: gray,
            cursorColor: colorProvider.primaryLight(),
            selectionHandleColor: colorProvider.primaryLight()),
        inputDecorationTheme: InputDecorationTheme(
          focusColor: colorProvider.primary(),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: 2, color: colorProvider.primaryLight()),
          ),
          border: const OutlineInputBorder(),
          iconColor: colorProvider.primaryLight(),
          fillColor: colorProvider.primaryLight(),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: 2, color: colorProvider.primaryLight()),
          ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: colorProvider.primary(),
            secondary: colorProvider.primaryLight(),
            error: error));
  }
}
