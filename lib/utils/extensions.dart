import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

import '../styles/text.dart';

extension BoolParsing on String {
  bool parseBool() {
    if (toLowerCase() == 'true') {
      return true;
    } else if (toLowerCase() == 'false') {
      return false;
    }

    throw '"$this" can not be parsed to boolean.';
  }
}

extension ErrorWidget on State {
  Widget errorWidget(String errorMessage) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
            child: Lottie.asset("assets/img/transaction-failed.json",
                repeat: false, width: 100, height: 100)),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
              child: Text(
            errorMessage,
            style: titleStyleText("", 20),
          )),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
