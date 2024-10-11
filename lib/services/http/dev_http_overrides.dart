import 'dart:io';

import 'package:logger/logger.dart';

class DevHttpOverrides extends HttpOverrides {
  final _logger = Logger();

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        // _logger.i(host);
        return true;
      };
  }
}
