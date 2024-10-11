import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';

@injectable
class LocationPermsCheck {
  final _logger = Logger();

  StreamSubscription<LocationData>? _locationSubscription;
  final _location = Location();

  Future<LocationPermsResult> _handlePerms(
      bool triggerAsk, PermissionStatus permissionStatus) async {
    switch (permissionStatus) {
      case PermissionStatus.granted:
      case PermissionStatus.grantedLimited:
        //_pendingDeviceScan = true;

        var serviceEnabled = await _location.serviceEnabled();
        if (serviceEnabled) {
          _locationStream();
          _logger.i("location serviceEnabled");
          return LocationPermsResult(true, permissionStatus);
        }

        _logger.i("request service");

        return _location.requestService().then((value) {
          if (value) {
            _locationStream();
          }

          return LocationPermsResult(value, permissionStatus);
        });
      case PermissionStatus.denied:
        if (triggerAsk) {
          //_pendingDeviceScan = true;
          _logger.i("request permission");
          return _handlePerms(false, await _location.requestPermission());
        }

        return LocationPermsResult(false, permissionStatus);
        //_pendingDeviceScan = false;
      /*  add(const BluetoothDeviceScanErrorEvent(
            "Permiso de gps esta denegado"));

        return false;*/

      case PermissionStatus.deniedForever:
        return LocationPermsResult(false, permissionStatus);
        //_pendingDeviceScan = false;
      /*  add(const BluetoothDeviceScanErrorEvent(
            "Permiso de gps esta deshabilitado"));

        return false;*/
    }
  }

  Future<LocationPermsResult> checkLocation() async {
    return _handlePerms(true, await _location.hasPermission());
  }

  void _locationStream() async {
   /* _locationSubscription?.cancel();
    _locationSubscription = _location.onLocationChanged.listen((event) {
      // _logger.i("LOCATION_CHANGED $event");
      *//* if (_locationData == null && _mydevice == null) {
        _scan();
      }*//*
      _locationData = event;
      isLocationEnabled = true;
    });*/
  }
}

class LocationPermsResult {
  final bool success;
  final PermissionStatus status;

  LocationPermsResult(this.success, this.status);
}
