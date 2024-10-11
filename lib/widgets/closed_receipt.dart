import "package:flutter/material.dart";

import '../styles/text.dart';

class ClosedReceipt extends StatefulWidget {
  final List data;

  const ClosedReceipt({super.key, required this.data});

  @override
  State<ClosedReceipt> createState() => _ClosedReceiptState();
}

class _ClosedReceiptState extends State<ClosedReceipt> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Text(
                "RESULTADO DEL CIERRE",
                style: titleStyleText("", 18),
              ),
            )),
        const SizedBox(height: 20),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < widget.data.length; i++)
                    widget.data[i]["message"] == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text(
                                    "Afiliación: ${widget.data[i]["affiliation"].toString()}",
                                    style: titleStyleText("", 18)),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                    "Terminal: ${widget.data[i]["terminal"].toString()} (${widget.data[i]["type"].toString()})",
                                    style: subtitleStyleText("", 18)),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Compra: ${widget.data[i]["amount_buy"].toString()} (${widget.data[i]["count_buy"].toString()})",
                                            style: subtitleStyleText("", 18),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Anulación: ${widget.data[i]["amount_anulate"].toString()} (${widget.data[i]["count_anulate"].toString()})",
                                            style: subtitleStyleText("", 18),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Total: ${widget.data[i]["total"].toString()} (${widget.data[i]["count_total"].toString()})",
                                            style: subtitleStyleText("", 18),
                                          )
                                        ],
                                      )
                                    ]),
                                const SizedBox(
                                  height: 50,
                                ),
                              ])
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Afiliación: ${widget.data[i]["affiliation"].toString()}",
                                  style: titleStyleText("", 18)),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                  "Terminal: ${widget.data[i]["terminal"].toString()} (${widget.data[i]["type"].toString()})",
                                  style: subtitleStyleText("", 18)),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(widget.data[i]["message"],
                                      style: subtitleStyleText("", 16)),
                                ],
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                            ],
                          )
                ])),
      ],
    ));
  }
}
