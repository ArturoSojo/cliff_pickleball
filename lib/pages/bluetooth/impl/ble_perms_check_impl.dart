import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

import '../ble_perms_check.dart';

@Injectable(as: BlePermsCheck)
class BlePermsCheckImpl extends BlePermsCheck {
  final _logger = Logger();
  final _deviceInfo = DeviceInfoPlugin();

  Future<String> _checkPerms(Permission permission,
      {bool? triggerAsk, PermissionStatus? status}) async {
    if (triggerAsk == null || status == null) {
      return _checkPerms(permission,
          triggerAsk: true, status: await permission.status);
    }

    //_logger.i("${permission.toString()} status $status");

    switch (status) {
      case PermissionStatus.denied:
        if (triggerAsk) {
          return _checkPerms(permission,
              triggerAsk: false, status: await permission.request());
        }

        return "Permiso para usar el bluetooth ha sido denegado";
      case PermissionStatus.granted:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
        return "";
      case PermissionStatus.permanentlyDenied:
        return "Permiso para usar el bluetooth ha sido permanentemente denegado";
    }
  }

  @override
  Future<String> checkBlePermissions() async {
    var sdkInt = (await _deviceInfo.androidInfo).version.sdkInt;
    var perms = sdkInt >= 31
        ? [
            Permission.bluetoothAdvertise,
            Permission.bluetoothConnect,
            Permission.bluetoothScan
          ]
        : [
            Permission.bluetooth,
            Permission.bluetoothAdvertise,
            Permission.bluetoothConnect,
            Permission.bluetoothScan
          ];

    var futures = perms.map(_checkPerms).toList();

    var list = await Future.wait(futures);

    return list.firstWhere((element) => element.isNotEmpty, orElse: () => "");
  }

  @override
  Future<void> openSettings() async {
    openAppSettings();
  }
}
