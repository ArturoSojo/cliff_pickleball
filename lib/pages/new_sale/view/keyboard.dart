import 'package:flutter/material.dart';

import '../../../styles/bg.dart';
import '../../../styles/text.dart';

const double size = 23;
const double sizeClear = size + 4;

class Keyboard extends StatelessWidget {
  final Function(KeyboardKey) callback;

  const Keyboard(this.callback, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        keyRow([KeyboardKey._7, KeyboardKey._8, KeyboardKey._9]),
        keyRow([KeyboardKey._4, KeyboardKey._5, KeyboardKey._6]),
        keyRow([KeyboardKey._1, KeyboardKey._2, KeyboardKey._3]),
        keyRow([KeyboardKey.CLEAR_ALL, KeyboardKey._0, KeyboardKey.CLEAR])
      ],
    );
  }

  Widget keyRow(List<KeyboardKey> keys) {
    return Row(children: keys.map(btn).toList());
  }

  Widget btn(KeyboardKey key) {
    double keySize = 100;
    return Expanded(
      child: Material(
        child: Ink(
          width: keySize,
          height: keySize,
          decoration: BoxDecoration(
            border: Border.all(color: ColorUtil.gray, width: 0.4),
            // borderRadius:
            //     const BorderRadius.only(topLeft: Radius.circular(10)),
            color: ColorUtil.white,
          ),
          child: InkWell(
            onTap: () => callback(key),
            child: Center(child: _keyValue(key)),
          ),
        ),
      ),
    );
  }

  Widget _keyValue(KeyboardKey key) {
    switch (key) {
      case KeyboardKey.CLEAR_ALL:
        return Text("C", style: subtitleStyleText("error", size));
      case KeyboardKey.CLEAR:
        return const Image(
            image: AssetImage("assets/img/delete.png"),
            height: sizeClear,
            width: sizeClear);
      default:
        return Text(key.name.substring(1), style: subtitleStyleText("", size));
    }
  }
}

enum KeyboardKey {
  _1,
  _2,
  _3,
  _4,
  _5,
  _6,
  _7,
  _8,
  _9,
  _0,
  CLEAR,
  CLEAR_ALL;
}
