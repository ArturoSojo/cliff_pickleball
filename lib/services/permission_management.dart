import 'package:permission_handler/permission_handler.dart';

class PermissionManagement {
  Future<bool> recordingPermission() async {
    final status = await Permission.microphone.request();
    return status == PermissionStatus.granted;
  }

  Future<bool> storagePermission() async {
    final status = await Permission.manageExternalStorage.status;
    if (status.isGranted) {
      // Permiso ya concedido
      return true;
    } else {
      // Solicitar permiso
      final result = await Permission.manageExternalStorage.request();
      if (result == PermissionStatus.granted) {
        // Permiso concedido
        return true;
      } else {
        // Permiso denegado
        print("Permiso de almacenamiento denegado");
        return false;
      }
    }
  }

  Future<bool> locationPermission() async {
    final status = await Permission.location.request();
    return status == PermissionStatus.granted;
  }

  Future<bool> contactPermission() async {
    final status = await Permission.contacts.request();
    return status == PermissionStatus.granted;
  }
}
