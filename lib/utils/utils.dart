import 'dart:io';
import 'dart:math';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/http/result.dart';
import 'extensions.dart';

abstract class MyUtils {
  static final Random random = Random();

  static final RegExp REX_EMAIL = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  static final Set<String> nonAuthServices = {
    "/oauth/authorize",
    "/oauth/info_from_credentials"
  };

  static parseDNI(dni) {
    dni = dni.padLeft((9), "0");
    return dni;
  }

  static bool get showSplashScreen =>
      dotenv.env['SHOW_SPLASH_SCREEN']?.parseBool() ?? false;

  static bool get randomTheme =>
      dotenv.env['RANDOM_THEME']?.parseBool() ?? false;

  static String get authId => dotenv.env['AUTH_ID'] ?? '';

  static String get authContextPath => dotenv.env['AUTH_CONTEXT_PATH'] ?? '';

  static String get urlContextPath => dotenv.env['URL_CONTEXT_PATH'] ?? '';

  static String get type => dotenv.env['CONTEXT_PATH'] ?? '';

  static String get clientId => dotenv.env['CLIENT_ID'] ?? '';

  static String get clientIdRole => dotenv.env['CLIENT_ID_ROLE'] ?? '';

  static String get clientIdPos => dotenv.env['CLIENT_ID_POS'] ?? '';

  static String get clientIdServicePay => dotenv.env['CLIENT_ID_SERVICEPAY'] ?? '';

  static String get base => dotenv.env['API_URL'] ?? '';

  static String get publicKey => dotenv.env['PASSWORD_PUBLIC_KEY'] ?? '';

  static bool get disableSslVerification =>
      dotenv.env['DISABLE_SSL_VERIFICATION']?.parseBool() ?? false;

  // static const String client_id = "210d8421-9222-41a0-926a-23be3dfe7608"; // QA
  // static const String base = "apiq.credicard.com.ve"; // QA

  static String pinPad = "$type/pin_pad/";
  static String uri = "$type/pin_pad/payment";

  static Map<String, String> params = {};
  static Map<String, String> params2 = {};

  static Map<String, String> headers = {
    "Content-type": "application/json",
    'Accept': 'application/json',
  };
  static Map<String, String> headers2 = {
    "Content-type": "application/x-www-form-urlencoded",
  };

  static void testLoadDemo() {
    dotenv.testLoad(fileInput: File('env.demo').readAsStringSync());
  }

  static void testLoadQA() {
    dotenv.testLoad(fileInput: File('env.qa').readAsStringSync());
  }

  static Future<void> loadDemo() {
    return dotenv.load(fileName: "env.demo");
  }

  static Future<void> loadQA() {
    return dotenv.load(fileName: "env.qa");
  }

  static Future<void> loadPROD() {
    return dotenv.load(fileName: "env.prod");
  }

  static Future<Result<T>> nextResult<T, S>(
      Result<S> result, Future<Result<T>> Function(Result<S> result) function) {
    if (!result.success) {
      return Future.value(Result.transform(result));
    }

    return function(result);
  }
  static double? parseAmount(amount){
    switch(amount.runtimeType){
      case String:
        var parsedAmount = double.tryParse(amount);
        bool parse = parsedAmount?.isFinite ?? false;
        return parse ? parsedAmount : null;
      case int:
        return double.parse(amount.toString());
      case double:
        return amount;
    }
    return null;
  }
  static double? parseAmountInt(dynamic amount){
    switch(amount.runtimeType){
      case String:
        var parsedAmount = double.tryParse(amount);
        bool parse = parsedAmount?.isFinite ?? false;
        if(parsedAmount!.isNaN){
          return null;
        } 
        return parse ? parsedAmount : null;
      case int:
        return double.parse(amount);
      case double:
        return amount;
    }
    return null;
  }

  static Future<SharedPreferences> prefs() {
    return SharedPreferences.getInstance();
  }

  static final Map<String, String> operador = {
    "MOVISTAR": r'\((414|424)\)\s+[0-9]{3}\-[0-9]{4}',
    "MOVILNET": r'\((416|426)\)\s+[0-9]{3}\-[0-9]{4}',
    "DIGITEL": r'\((412)\)\s+[0-9]{3}\-[0-9]{4}',
  };

  static final Map<String, String> operadorNumber = {
    "MOVISTAR": "ejemplo: (414) ###-####",
    "MOVILNET": "ejemplo: (416) ###-####",
    "DIGITEL": "ejemplo: (412) ###-####",
    "DEFAULT": "ejemplo: (###) ###-####",
  };
}
