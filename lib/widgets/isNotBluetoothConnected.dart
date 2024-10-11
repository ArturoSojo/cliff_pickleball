import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../styles/bg.dart';
import '../styles/text.dart';

class IsNotBluetoothConnected extends StatefulWidget {
  final String message;

  const IsNotBluetoothConnected({super.key, required this.message});

  @override
  State<IsNotBluetoothConnected> createState() =>
      _IsNotBluetoothConnectedState();
}

class _IsNotBluetoothConnectedState extends State<IsNotBluetoothConnected> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Image(
                    image: AssetImage("assets/img/pos.png"),
                    height: 80,
                    width: 80),
                const SizedBox(height: 20),
                Text(widget.message, style: subtitleStyleText("", 18)),
                const SizedBox(height: 2),
                Container(
                  margin: const EdgeInsets.fromLTRB(4, 15, 4, 20),
                  child: ElevatedButton(
                    style: TextButton.styleFrom(
                        backgroundColor: ColorUtil.primaryColor(),
                        padding: const EdgeInsets.all(20)),
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "CONECTAR DISPOSITIVO",
                              selectionColor: ColorUtil.primaryColor(),
                              style: subtitleStyleText("white", 18),
                            )
                          ],
                        )),
                    onPressed: () {
                      setState(() {
                        context.go("/bluetooth");
                      });
                    },
                  ),
                )
              ],
            ),
          ],
        ),
    );
  }
}
