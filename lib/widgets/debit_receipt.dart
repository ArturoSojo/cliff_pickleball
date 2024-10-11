import "package:flutter/material.dart";

import '../styles/bg.dart';
import '../styles/text.dart';

class DebitReceipt extends StatefulWidget {
  const DebitReceipt({super.key});

  @override
  State<DebitReceipt> createState() => _DebitReceiptState();
}

class _DebitReceiptState extends State<DebitReceipt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(children: [
          Container(
            height: 70,
            color: ColorUtil.primaryColor(),
          ),
          Column(children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Recibo #0000001", style: titleStyleText("", 20))
                  ],
                )),
            const SizedBox(
              height: 20,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                          child: Text(
                              "Banco de venezuela S.A.C.A Banco universal",
                              textAlign: TextAlign.center,
                              style: titleStyleText("", 18))),
                      const SizedBox(height: 4),
                      Text("(J22222222)", style: titleStyleText("", 18)),
                      const SizedBox(height: 4),
                      Text("Recibo de compra", style: titleStyleText("", 18)),
                      const SizedBox(height: 4),
                      Text("MAESTRO", style: titleStyleText("", 18)),
                      const SizedBox(height: 4),
                    ])),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Angel Lugo", style: titleStyleText("", 18)),
                            const SizedBox(height: 4),
                            Text("Plaza venezuela",
                                style: subtitleStyleText("", 16)),
                            const SizedBox(height: 4),
                            Row(children: [
                              Text("RIF: V00503096",
                                  style: subtitleStyleText("", 16)),
                              const SizedBox(
                                width: 6,
                              ),
                              Text("Afiliado: 10000009",
                                  style: subtitleStyleText("", 16))
                            ]),
                            const SizedBox(height: 4),
                            Row(children: [
                              Text("TERMINAL: 1031",
                                  style: subtitleStyleText("", 16)),
                              const SizedBox(
                                width: 6,
                              ),
                              Text("LOTE: 1", style: subtitleStyleText("", 16))
                            ]),
                            const SizedBox(height: 4),
                            Text("441132*******2587",
                                style: titleStyleText("", 16)),
                            const SizedBox(height: 4),
                            Row(children: [
                              Text("fecha: 14/11/22",
                                  style: subtitleStyleText("", 16)),
                              const SizedBox(
                                width: 6,
                              ),
                              Text("hora: 05:01:22 P.M",
                                  style: subtitleStyleText("", 16))
                            ]),
                            Row(
                              children: [
                                Text("APROB: 837607",
                                    style: subtitleStyleText("", 16)),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text("REF: 000018",
                                    style: subtitleStyleText("", 16)),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text("TRACE: 000025",
                                    style: subtitleStyleText("", 16)),
                                const SizedBox(
                                  width: 6,
                                ),
                              ],
                            )
                          ]),
                    ]))
          ])
        ]),
        Column(children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Monto:", style: titleStyleText("", 16)),
                    Text(
                      "Bs. 250.00",
                      style: titleStyleText("", 16),
                    ),
                  ])),
          const SizedBox(height: 20),
          const SizedBox(height: 10),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text("NO SE REQUIERE FIRMA",
                  textAlign: TextAlign.center,
                  style: subtitleStyleText("warning", 16))),
          const SizedBox(height: 10),
        ]),
      ],
    ));
  }
}
