import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:cliff_pickleball/services/cacheService.dart';
import 'package:cliff_pickleball/utils/showErrorMessage.dart';

import '../domain/merchant_device_response.dart';
import '../styles/bg.dart';
import '../styles/text.dart';

class SimpleReceipt extends StatefulWidget {
  final Map<String, dynamic> data;
  final String type;

  const SimpleReceipt({super.key, required this.data, required this.type});

  @override
  State<SimpleReceipt> createState() => _SimpleReceiptState();
}

class _SimpleReceiptState extends State<SimpleReceipt> {
  final format = DateFormat(
    'dd/MM/yy',
  );
  DateFormat format2 = DateFormat('hh:mm:ss a');
  DateTime date = DateTime.now().toLocal();
  late String hora;
  late String fecha;
  MerchantDeviceResponse? merchantInformation;
  final Cache _cache = Cache();

  @override
  void initState() {
    super.initState();
    print("terminal: ${widget.data["count3"].toString()}");
    fecha = format.format(date);
    hora = format2.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _cache.getDeviceInformation(),
        builder: (context, AsyncSnapshot snapshot) {
          var merchantInformation = snapshot.data;
          if (merchantInformation == null) {
            return showErrorMessage(
                "Error al obtener la información del dispositivo");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (merchantInformation == null) {
              return showErrorMessage(
                  "Error al obtener la información del dispositivo");
            }
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
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
                                merchantInformation!
                                            .device!
                                            .merchantAffiliations![0]
                                            .bankName !=
                                        null
                                    ? Center(
                                        child: Text(
                                            merchantInformation!
                                                    .device!
                                                    .merchantAffiliations![0]
                                                    .bankName ??
                                                "",
                                            textAlign: TextAlign.center,
                                            style: titleStyleText("", 16)))
                                    : SizedBox(),
                                const SizedBox(height: 4),
                                merchantInformation!.device!
                                            .merchantAffiliations![0].bankRif !=
                                        null
                                    ? Text(
                                        "(${merchantInformation!.device!.merchantAffiliations![0].bankRif ?? ""})",
                                        style: titleStyleText("", 16))
                                    : SizedBox(),
                                const SizedBox(height: 4),
                                Text(
                                    "Reporte ${widget.type} de transacciones"
                                        .toUpperCase(),
                                    style: titleStyleText("", 16)),
                                const SizedBox(height: 4),
                              ])),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 16),
                                      Row(children: [
                                        Text(
                                            merchantInformation!
                                                    .device!.commerceName ??
                                                "",
                                            style: subtitleStyleText("", 16)),
                                      ]),
                                      Row(children: [
                                        Text(
                                            merchantInformation!
                                                    .device!.store!.address ??
                                                "",
                                            style: subtitleStyleText("", 16)),
                                      ]),
                                      Row(children: [
                                        Text(
                                            "RIF: ${merchantInformation!.device!.commerceIdDoc ?? ""}",
                                            style: subtitleStyleText("", 16)),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                            "Afiliado: ${merchantInformation!.device!.merchantAffiliations![0].affiliationNumber ?? ""}",
                                            style: subtitleStyleText("", 16))
                                      ]),
                                      const SizedBox(height: 4),
                                      Row(children: [
                                        Text(
                                            "TERMINAL: ${widget.data["terminal"] ?? ""}",
                                            style: subtitleStyleText("", 16)),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Text("LOTE: ${widget.data["lote"]}",
                                            style: subtitleStyleText("", 16))
                                      ]),
                                      Row(children: [
                                        Text("fecha: $fecha".toUpperCase(),
                                            style: subtitleStyleText("", 16)),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Text("hora: ${hora}".toUpperCase(),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    "compra(${widget.data["count2"]})"
                                        .toUpperCase(),
                                    style: titleStyleText("", 16)),
                                Text(
                                  widget.data["aprobados"],
                                  style: titleStyleText("", 16),
                                ),
                              ])),
                      widget.data["count3"].toString() != "0"
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "anulación(${widget.data["count3"]})"
                                            .toUpperCase(),
                                        style: titleStyleText("", 16)),
                                    Text(
                                      widget.data["anulado"],
                                      style: titleStyleText("", 16),
                                    ),
                                  ]))
                          : const SizedBox(),
                      widget.type == "total"
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "total(${widget.data["count"]})"
                                            .toUpperCase(),
                                        style: titleStyleText("", 16)),
                                    Text(
                                      widget.data["total"],
                                      style: titleStyleText("", 16),
                                    ),
                                  ]))
                          : const SizedBox(height: 10),
                    ]),
                  ]),
                ],
              ),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                    child: SizedBox(
                        width: 70,
                        height: 70,
                        child: CircularProgressIndicator(
                          color: ColorUtil.primaryColor(),
                          strokeWidth: 6,
                        ))),
                const SizedBox(
                  height: 10,
                ),
                Center(
                    child: Text(
                  'Obteniendo información del dispositivo',
                  style: titleStyleText("", 20),
                )),
              ],
            );
          }
          return showErrorMessage(
              "Error al obtener la informacion del disposiivo");
        });
  }
}
