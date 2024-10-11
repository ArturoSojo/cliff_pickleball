import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:cliff_pickleball/services/http/result.dart';
import 'package:cliff_pickleball/utils/translate.dart';

import '../../domain/message.dart';

class HttpUtil {
  static Result<T> result<T>(Response response, T Function(dynamic)? func) {
    if (response.statusCode == 200) {
      if (func != null) {
        var body = func(jsonDecode(response.body));
        return Result.success(body);
      }

      return Result.success(null);
    }

    if (response.statusCode == 202 || response.statusCode == 422) {
      var message = Message.fromJson(jsonDecode(response.body));

      var errorMsg = message.message;
      var cause = message.cause;

      String error = "";

      if (errorMsg != null) {
        error += translate(errorMsg);
      }

      if (cause != null) {
        var join = cause.map(translate).join(", ");

        if (join.isNotEmpty) {
          error += ", $join";
        }
      }

      if (error.isEmpty) {
        error = "EMPTY_ERROR";
      }

      return Result<T>.msg(message, errorMessage: error);
    }

    if (response.statusCode == 401) {
      return Result.failMsg("Acceso denegado");
    }

    if (response.statusCode == 403) {
      return Result.failMsg("No hay permisos para acceder a este recurso");
    }

    if (response.statusCode == 502) {
      return Result.failMsg("Gateway timeout");
    }

    if (response.statusCode == 503) {
      return Result.failMsg("Service Unavailable");
    }

    return Result<T>.failMsg("${response.statusCode} ${response.body}");
  }

  static Result<T> failResult<T>(Object? error, StackTrace stackTrace) {
    if (error is SocketException || error is ClientException) {
      return Result.failWithErrorMessage(
          "Error de conexión de internet", error, stackTrace);
    }

    return Result.fail(error, stackTrace);
  }
}
