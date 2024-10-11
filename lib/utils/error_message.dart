import "package:flutter/material.dart";
import "package:lottie/lottie.dart";

class ShowErrorMessage extends StatelessWidget {
  String errorMessage;
  bool error;
  ShowErrorMessage({Key? key, this.errorMessage = "NO HAY SERVICIOS DISPONIBLE", this.error = false}) : super(key: key);

  LottieBuilder get asset => error ?
  Lottie.asset("assets/img/transaction-failed.json", repeat: false, width: 100, height: 100) :
  Lottie.asset("assets/img/warning.json", repeat: false, width: 100, height: 100);

  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
            child: asset),
        const SizedBox(height: 10),
        Text(errorMessage, textAlign: TextAlign.center,),
      ],
    );
  }
}
