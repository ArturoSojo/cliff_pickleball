import "package:flutter/material.dart";
import 'package:go_router/go_router.dart';
import 'package:cliff_pickleball/utils/staticNamesRoutes.dart';

import '../styles/bg.dart';
import '../styles/text.dart';
import '../utils/receipData.dart';

class CreditReceipt extends StatefulWidget {
  final Map data;

  const CreditReceipt({super.key, required this.data});

  @override
  State<CreditReceipt> createState() => _CreditReceiptState();
}

class _CreditReceiptState extends State<CreditReceipt> {
  late Map<String, dynamic> data_f;

  @override
  void initState() {
    data_f = ReceiptData.getReceipt(widget.data);
    super.initState();
  }

  void parseData() async {
    setState(() {
      data_f = ReceiptData.getReceipt(widget.data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
            body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(children: [
              Container(
                color: ColorUtil.primaryColor(),
                height: 60,
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
                            child: Icon(Icons.west,
                                size: 25, color: ColorUtil.white),
                            onTap: () => context.go(StaticNames.homeName.path)),
                        InkWell(
                            child: Icon(Icons.home, color: ColorUtil.white),
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
                              child: Text(data_f["banco"].toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: titleStyleText("", 16))),
                          const SizedBox(height: 4),
                          Text("(${data_f["banco_rif"]})",
                              style: titleStyleText("", 16)),
                          const SizedBox(height: 4),
                          Text("Recibo de compra".toUpperCase(),
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
              data_f["type_payment"] == "TDD"
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
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
        )),
      ),
    );
  }
}
