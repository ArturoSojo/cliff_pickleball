import 'dart:io';
import 'package:url_launcher/url_launcher.dart'; // Importa url_launcher
import 'debugging.dart';

class SystemFileManagement {
  static Future<void> openFile(String filePath) async {
    try {
      // Usa url_launcher para abrir el archivo
      final Uri uri = Uri.file(filePath);
      if (await canLaunch(uri.toString())) {
        await launch(uri.toString());
      } else {
        debugShow('Could not launch $filePath');
      }
    } catch (e) {
      debugShow('Error opening file: $e');
    }
  }

  static deleteFile(String filePath) async {
    try {
      debugShow('Attempting Deleting media file from local storage $filePath');
      await File(filePath).delete(recursive: true);
      debugShow('Local File $filePath deleted');
    } catch (e) {
      debugShow('Error in Delete File: $e');
    }
  }
}
