import 'package:flutter/material.dart';
import 'package:cliff_pickleball/styles/bg.dart';

import '../../../styles/text.dart';
import '../new_sale_bloc.dart';
import '../presenter/input_presenter.dart';
import 'keyboard.dart';

class InputScreen extends StatelessWidget {
  final String title;
  final String btnTitle;
  final InputPresenter _presenter;
  final Function next;

  const InputScreen(this.title, this.btnTitle, this._presenter, this.next,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Column(children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 22, right: 22, top: 15),
            child: Center(child: Text(title, style: subtitleStyleText("", 16))),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              children: [
                Expanded(
                    child: Center(
                  child: StreamBuilder(
                      stream: _presenter.valueStream(),
                      builder: (context, snapshot) {
                        return TextField(
                          cursorColor: ColorUtil.primaryLightColor(),
                          readOnly: true,
                          showCursor: false,
                          controller:
                              TextEditingController(text: snapshot.data ?? ""),
                          keyboardType: TextInputType.none,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(
                              fontSize: 35.0, color: Colors.black),
                        );
                      }),
                ))
              ],
            ),
          )
        ]),
        Container(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 0),
            child: Column(
              children: [
                Keyboard(_presenter.addKey),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.fromLTRB(4, 25, 4, 20),
                          child: StreamBuilder(
                              stream: _presenter.isValid(),
                              builder: (context, snapshot) {
                                var isValid = snapshot.data ?? false;
                                return TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: isValid
                                          ? ColorUtil.primaryColor()
                                          : Colors.grey,
                                      padding: const EdgeInsets.all(20)),
                                  onPressed: !isValid ? null : () => next(),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(btnTitle,
                                          style:
                                              subtitleStyleText("white", 18)),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      StreamBuilder(
                                          stream: _presenter.btnValueStream(),
                                          builder: (context, snapshot) {
                                            return Text(
                                              snapshot.data ?? "",
                                              style: subtitleStyleText(
                                                  "white", 18),
                                            );
                                          }),
                                    ],
                                  ),
                                );
                              })),
                    )
                  ],
                )
              ],
            )),
      ],
    );
  }
}
