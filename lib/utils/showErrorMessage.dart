import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cliff_pickleball/utils/translate.dart';

import '../styles/text.dart';

Widget showErrorMessage(String errorMessage) {
  return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
            child: Lottie.asset(
                repeat: false,
                "assets/img/transaction-failed.json",
                width: 250,
                height: 140)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    translate(errorMessage),
                    style: titleStyleText("black", 20),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ]);
}
