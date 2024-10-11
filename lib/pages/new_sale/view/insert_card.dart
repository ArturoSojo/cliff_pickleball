import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cliff_pickleball/utils/translate.dart';

import '../../../styles/text.dart';
import '../new_sale_bloc.dart';

class InsertCardScreen extends StatelessWidget {
  final Stream<String> _amountStream;
  final Stream<String> _idDocStream;
  final Stream<String> _displayMessageStream;

  InsertCardScreen(
      this._amountStream, this._idDocStream, this._displayMessageStream,
      {super.key});

  final Future<LottieComposition> _composition =
      AssetLottie("assets/img/insert-card-2.json").load();

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaleFactor;
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Container(height: 100),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StreamBuilder(
                            stream: _amountStream,
                            builder: (context, snapshot) {
                              return Text(snapshot.data ?? "",
                                  style:
                                      titleStyleText("white", 40 * textScale));
                            }),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StreamBuilder(
                            stream: _idDocStream,
                            builder: (context, snapshot) {
                              return Text(snapshot.data ?? "",
                                  style: subtitleStyleText(
                                      "white", 30 * textScale));
                            })
                      ],
                    ),
                  ])),

          const SizedBox(height: 10),
          FutureBuilder<LottieComposition>(
            future: _composition,
            builder: (context, snapshot) {
              var composition = snapshot.data;
              if (composition != null) {
                return Lottie(composition: composition);
              } else {
                return const SizedBox();
              }
            },
          ),
          const SizedBox(height: 10),
          StreamBuilder(
              stream: _displayMessageStream,
              builder: (context, snapshot) {
                String message = translate(snapshot.data ?? "");
                return Text(message,
                    style: subtitleStyleText("white", 14 * textScale));
              }),
          const SizedBox(height: 10),
        ]);
  }
}
