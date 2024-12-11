import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:cliff_pickleball/config/secret_data.dart';
import 'package:cliff_pickleball/config/text_collection.dart';
import 'package:cliff_pickleball/services/local_data_management.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter/material.dart' hide Key;

class Secure {
  static Key key = enc.Key.fromUtf8('4f1aaae66406e358');
  static IV iv = enc.IV.fromUtf8('df1e180949793972');

  // Method to encypt data
  static String? encode(String? plainText) {
    if (plainText == null) return null;
    final encrypter =
        enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc, padding: 'PKCS7'));
    final encrypted = encrypter.encrypt(plainText!, iv: iv);
    return encrypted.base64;
  }

  // Method to decrypt data
  /*static String decode(String? chipherText, {bool initialize = false}) {
    String decryptedString;
    try {
      final decrypter =
          enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc, padding: 'PKCS7'));
      final decrypted =
          decrypter.decryptBytes(Encrypted.from64(chipherText!), iv: iv);
      decryptedString = utf8.decode(decrypted);

      return decryptedString;
    } on Exception catch (e) {
      decryptedString = e.toString();
      return decryptedString ?? '';
    }
  }*/

  static String decode(String? encodedStringForm, {bool initialize = false}) {
    String decryptedString;
    try {
      if (encodedStringForm == null) return '';

      if (initialize) {
        key = enc.Key.fromUtf8('4f1aaae66406e358');
        iv = enc.IV.fromUtf8('df1e180949793972');
      }

      final decrypter =
          enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc, padding: 'PKCS7'));
      final decrypted =
          decrypter.decryptBytes(Encrypted.from64(encodedStringForm!), iv: iv);
      decryptedString = utf8.decode(decrypted);

      return decryptedString;
    } catch (e) {
      // Maneja cualquier excepción aquí
      print('Error decoding string: $e');

      // Intenta inicializar nuevamente si hay un error de inicialización
      if (e.toString().contains('NotInitializedError')) {
        return decode(encodedStringForm, initialize: true);
      }

      return encodedStringForm ?? '';
    }
  }

  /*static Key _key =
      Key.fromBase64(DataManagement.getEnvData(EnvFileKey.encryptKey) ?? '');
  static IV _iv = IV.fromLength(16);
  static Encrypter _makeEncryption =
      Encrypter(AES(_key, mode: AESMode.ctr, padding: null));*/

  /* static String? encode(String? plainText) {
    if (plainText == null) return null;
    final Encrypted encrypted = _makeEncryption.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  static String decode(String? encodedStringForm, {bool initialize = false}) {
    try {
      if (encodedStringForm == null) return '';

      if (initialize) {
        _key = Key.fromBase64(SecretData.encryptKey);
        _iv = IV.fromLength(16);
        _makeEncryption =
            Encrypter(AES(_key, mode: AESMode.ctr, padding: null));
      }

      final String decrypted =
          _makeEncryption.decrypt64(encodedStringForm, iv: _iv);

      return decrypted;
    } catch (e) {
      // Maneja cualquier excepción aquí
      print('Error decoding string: $e');

      // Intenta inicializar nuevamente si hay un error de inicialización
      if (e.toString().contains('NotInitializedError')) {
        return decode(encodedStringForm, initialize: true);
      }

      return encodedStringForm ?? '';
    }
  }*/
}
