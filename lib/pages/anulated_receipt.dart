import "package:flutter/material.dart";
import 'package:go_router/go_router.dart';
import 'package:cliff_pickleball/utils/staticNamesRoutes.dart';

import '../styles/bg.dart';
import '../styles/text.dart';

class AnulatedReceipt extends StatelessWidget {
  final Map<String, dynamic> data_f;

  const AnulatedReceipt(this.data_f, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: InkWell(
              child: const Icon(Icons.home, color: ColorUtil.white),
              onTap: () => context.go(StaticNames.homeName.path)),
          centerTitle: true,
          leading: IconButton(
              onPressed: (() => context.go(StaticNames.homeName.path)),
              icon: const Icon(Icons.arrow_back_sharp)),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(children: [
              Column(children: [
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
                              child: Text(data_f["banco"].toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: titleStyleText("", 16))),
                          const SizedBox(height: 4),
                          Text("(${data_f["banco_rif"]})",
                              style: titleStyleText("", 16)),
                          const SizedBox(height: 4),
                          Text("Anulación".toUpperCase(),
                              style: titleStyleText("", 16)),
                          const SizedBox(height: 4),
                          Text(data_f["emisor"], style: titleStyleText("", 16)),
                          const SizedBox(height: 10),
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
                                const SizedBox(height: 20),
                                Text(data_f["comercio"].toUpperCase(),
                                    style: subtitleStyleText("", 16)),
                                const SizedBox(height: 4),
                                Text(data_f["address"].toUpperCase(),
                                    style: subtitleStyleText("", 16)),
                                const SizedBox(height: 4),
                                Row(children: [
                                  Text("RIF: ${data_f["rif"]}",
                                      style: subtitleStyleText("", 16)),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                      "Afiliado: ${data_f["afiliacion"]}"
                                          .toUpperCase(),
                                      style: subtitleStyleText("", 16))
                                ]),
                                const SizedBox(height: 4),
                                Row(children: [
                                  Text(
                                      "TERMINAL: ${data_f["device"]}"
                                          .toUpperCase(),
                                      style: subtitleStyleText("", 16)),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text("LOTE: ${data_f["lote"]}",
                                      style: subtitleStyleText("", 16))
                                ]),
                                const SizedBox(height: 4),
                                Text(data_f["tarjeta"],
                                    style: titleStyleText("", 16)),
                                const SizedBox(height: 4),
                                Row(children: [
                                  Text(
                                      "fecha: ${data_f["fecha"]}".toUpperCase(),
                                      style: subtitleStyleText("", 16)),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text("hora: ${data_f["hora"]}".toUpperCase(),
                                      style: subtitleStyleText("", 16))
                                ]),
                                Row(
                                  children: [
                                    Text("APROB: ${data_f["approval"]}",
                                        style: subtitleStyleText("", 16)),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text("REF: ${data_f["reference"]}",
                                        style: subtitleStyleText("", 16)),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                        "TRACE: ${data_f["secuencia"].toString()}",
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
                        Text("Monto:".toUpperCase(),
                            style: titleStyleText("", 16)),
                        Text(
                          "${data_f["monto"]}",
                          style: titleStyleText("", 16),
                        ),
                      ])),
              const SizedBox(height: 20),
            ]),
          ],
        ));
  }
}
