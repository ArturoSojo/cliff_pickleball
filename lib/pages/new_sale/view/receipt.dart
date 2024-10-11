import "package:flutter/material.dart";
import 'package:go_router/go_router.dart';
import 'package:cliff_pickleball/styles/theme_provider.dart';
import 'package:cliff_pickleball/utils/staticNamesRoutes.dart';

import '../../../di/injection.dart';
import '../../../styles/bg.dart';
import '../../../styles/text.dart';

class Receipt extends StatelessWidget {
  final Map data;

  const Receipt(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(children: [
          Container(
            color: ColorUtil.primaryColor(),
            height: 90,
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
                        child: const Icon(Icons.west,
                            size: 25, color: ColorUtil.white),
                        onTap: () => context.go(StaticNames.homeName.path)),
                    InkWell(
                        child: const Icon(Icons.home, color: ColorUtil.white),
                        onTap: () => context.go(StaticNames.homeName.path)),
                    const Text(""),
                  ],
                )),
          ),
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
                          child: Text(data["banco"].toUpperCase(),
                              textAlign: TextAlign.center,
                              style: titleStyleText("", 16))),
                      const SizedBox(height: 4),
                      Text("(${data["banco_rif"]})",
                          style: titleStyleText("", 16)),
                      const SizedBox(height: 4),
                      Text("Recibo de compra".toUpperCase(),
                          style: titleStyleText("", 16)),
                      const SizedBox(height: 4),
                      Text(data["emisor"], style: titleStyleText("", 16)),
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
                            Text(data["comercio"].toUpperCase(),
                                style: subtitleStyleText("", 16)),
                            const SizedBox(height: 4),
                            Text(data["address"].toUpperCase(),
                                style: subtitleStyleText("", 16)),
                            const SizedBox(height: 4),
                            Row(children: [
                              Text("RIF: ${data["rif"]}",
                                  style: subtitleStyleText("", 16)),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                  "Afiliado: ${data["afiliacion"]}"
                                      .toUpperCase(),
                                  style: subtitleStyleText("", 16))
                            ]),
                            const SizedBox(height: 4),
                            Row(children: [
                              Text("TERMINAL: ${data["device"]}".toUpperCase(),
                                  style: subtitleStyleText("", 16)),
                              const SizedBox(
                                width: 6,
                              ),
                              Text("LOTE: ${data["lote"]}",
                                  style: subtitleStyleText("", 16))
                            ]),
                            const SizedBox(height: 4),
                            Text(data["tarjeta"],
                                style: titleStyleText("", 16)),
                            const SizedBox(height: 4),
                            Row(children: [
                              Text("fecha: ${data["fecha"]}".toUpperCase(),
                                  style: subtitleStyleText("", 16)),
                              const SizedBox(
                                width: 6,
                              ),
                              Text("hora: ${data["hora"]}".toUpperCase(),
                                  style: subtitleStyleText("", 16))
                            ]),
                            Row(
                              children: [
                                Text("APROB: ${data["approval"]}",
                                    style: subtitleStyleText("", 16)),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text("REF: ${data["reference"]}",
                                    style: subtitleStyleText("", 16)),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text("TRACE: ${data["secuencia"].toString()}",
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
                    Text("Monto:".toUpperCase(), style: titleStyleText("", 16)),
                    Text(
                      "${data["monto"]}",
                      style: titleStyleText("", 16),
                    ),
                  ])),
          const SizedBox(height: 20),
          data["type_payment"] == "TDD"
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Text("NO SE REQUIERE FIRMA",
                          textAlign: TextAlign.center,
                          style: subtitleStyleText("warning", 16)),
                      const SizedBox(height: 10),
                    ],
                  ))
              : Column(children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Firma:".toUpperCase(),
                                style: titleStyleText("", 16)),
                            const Text("_________________________________"),
                          ])),
                  const SizedBox(height: 10),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                          "Me obligo a pagar al banco emisor de esta tarjeta el monto de esta nota de consumo"
                              .toUpperCase(),
                          textAlign: TextAlign.center,
                          style: subtitleStyleText("warning", 16))),
                  const SizedBox(height: 10),
                ]),
        ]),
      ],
    );
  }
}
