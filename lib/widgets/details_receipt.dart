import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";

import '../styles/text.dart';

class DetailsReceipt extends StatefulWidget {
  final Map data;

  const DetailsReceipt({super.key, required this.data});

  @override
  State<DetailsReceipt> createState() => _DetailsReceiptState();
}

class _DetailsReceiptState extends State<DetailsReceipt> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                          child: Text(widget.data["bank_name"].toUpperCase(),
                              textAlign: TextAlign.center,
                              style: titleStyleText("", 18))),
                      const SizedBox(height: 4),
                      Text("(${widget.data["bank_rif"]})",
                          style: titleStyleText("", 18)),
                      const SizedBox(height: 4),
                      Text("REPORTE DETALLADO DE TRANSACCIONES".toUpperCase(),
                          style: titleStyleText("", 18)),
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
                            Text(widget.data["name"].toUpperCase(),
                                style: titleStyleText("", 18)),
                            const SizedBox(height: 4),
                            Text(widget.data["address"].toUpperCase(),
                                style: subtitleStyleText("", 16)),
                            const SizedBox(height: 4),
                            Row(children: [
                              Text("RIF: ${widget.data["commerce_id_doc"]}",
                                  style: subtitleStyleText("", 16)),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                  "Afiliado: ${widget.data["affiliation_number"]}"
                                      .toUpperCase(),
                                  style: subtitleStyleText("", 16))
                            ]),
                            const SizedBox(height: 4),
                            Row(children: [
                              Text(
                                  "TERMINAL: ${widget.data["terminal"]}"
                                      .toUpperCase(),
                                  style: subtitleStyleText("", 16)),
                              const SizedBox(
                                width: 6,
                              ),
                              Text("LOTE: ${widget.data["lote"]}",
                                  style: subtitleStyleText("", 16))
                            ]),
                            Row(children: [
                              Text(
                                  "fecha: ${widget.data["fecha"]}"
                                      .toUpperCase(),
                                  style: subtitleStyleText("", 16)),
                              const SizedBox(
                                width: 6,
                              ),
                              Text("hora: ${widget.data["hora"]}".toUpperCase(),
                                  style: subtitleStyleText("", 16))
                            ]),
                          ]),
                    ]))
          ])
        ]),
        Column(children: [
          const SizedBox(height: 20),
          Column(children: [
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("compra(${widget.data["count"]}):".toUpperCase(),
                          style: subtitleStyleText("", 16)),
                      Text(widget.data["monto"]),
                    ])),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("total(${widget.data["count"]}):".toUpperCase(),
                          style: subtitleStyleText("", 16)),
                      Text(widget.data["monto"]),
                    ])),
            const SizedBox(height: 10),
          ]),
        ]),
      ],
    );
  }
}
