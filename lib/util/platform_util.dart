import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class PlatformUtil {
  static Future<String> getDeviceName() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.model;
    }
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.utsname.machine.toString();
    }

    return Future.value("");
  }
}
