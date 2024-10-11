import 'package:flutter/material.dart';

import '../styles/bg.dart';
import '../styles/text.dart';

class Alerts {
  static AlertDialog error(String message, callback) {
    AlertDialog alert = AlertDialog(
      icon: const Icon(Icons.error_outline, size: 30),
      iconColor: ColorUtil.error,
      actions: [
        TextButton(
          onPressed: callback,
          child: Text(
            "Regresar",
            style: subtitleStyleText("", 16),
          ),
        )
      ],
      content: Text(message,
          style: subtitleStyleText("", 18), textAlign: TextAlign.center),
    );
    return alert;
  }

  static AlertDialog warning(String message, callback) {
    AlertDialog alert = AlertDialog(
      icon: const Icon(Icons.warning_amber, size: 30),
      iconColor: ColorUtil.warning,
      actions: [
        TextButton(
          onPressed: callback,
          child: Text(
            "Regresar",
            style: subtitleStyleText("", 16),
          ),
        )
      ],
      content: Text(message,
          style: subtitleStyleText("", 18), textAlign: TextAlign.center),
    );
    return alert;
  }
  static AlertDialog dialogTwoButtonActions({
    Widget child = const Text(""),
    List<String> actionButtonsNames = const ["REGRESAR","ACEPTAR"],
    callback, callbackTwo}) {
    AlertDialog alert = AlertDialog(
      icon: const Icon(Icons.warning_amber, size: 30),
      iconColor: ColorUtil.warning,
      actions: [
        TextButton(
            onPressed: callback,
            child: Text(actionButtonsNames[0], style: subtitleStyleText("", 16))
        ),
        TextButton(
            onPressed: callbackTwo,
            child: Text(actionButtonsNames[1], style: subtitleStyleText("", 16)
        ),
        )],
      content: child,
    );

    return alert;
  }
}
