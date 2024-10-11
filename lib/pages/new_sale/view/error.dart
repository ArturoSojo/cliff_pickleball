import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

import '../../../styles/text.dart';
import '../../../utils/translate.dart';

class ErrorView extends StatelessWidget {
  final String _error;

  const ErrorView(this._error, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Lottie.asset("assets/img/transaction-failed.json",
                  repeat: false, width: 250, height: 140)),
          Center(
            child: Text(
              translate(_error).toString(),
              style: titleStyleText("", 18),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
