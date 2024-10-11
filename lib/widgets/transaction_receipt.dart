import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:cliff_pickleball/pages/abstracts/base_page.dart';

import '../blocs/device_and_bluetooth/device_and_bluetooth_bloc.dart';
import '../styles/text.dart';
import 'isNotBluetoothConnected.dart';

class TransactionReceipt extends BasePage {
  final Map<String, dynamic> data;

  TransactionReceipt({super.key, required this.data});

  @override
  State<TransactionReceipt> createState() => _TransactionReceiptState();
}

class _TransactionReceiptState extends BaseState<TransactionReceipt>
    with BasicPage {
  late Map<String, dynamic> data;

  DeviceAndBluetoothBloc _bloc() {
    return context.read<DeviceAndBluetoothBloc>();
  }

  @override
  void initState() {
    _bloc().add(DeviceAndBluetoothInitialEvent());
    super.initState();
    Logger().i(widget.data);
    data = widget.data;
    print(data);
  }

  Widget _accountType({String? accountType}) {
    switch (accountType) {
      case "DEBITO":
      case "CORRIENTE":
      case "AHORRO":
      case "PRINCIPAL":
        return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text("NO SE REQUIERE FIRMA",
                    textAlign: TextAlign.center,
                    style: subtitleStyleText("warning", 16)),
                const SizedBox(height: 10)
              ],
            ));
      default:
        return Column(children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Firma:".toUpperCase(), style: titleStyleText("", 16)),
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
        ]);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget rootWidget(BuildContext context) {
    return BlocConsumer<DeviceAndBluetoothBloc, DeviceAndBluetoothState>(
      bloc: _bloc(),
      listener: (context, state) async {
        if (state is DeviceAndBluetoothInitialEvent) {
          await _bloc().getBluetoothDevice();
        }
      },
      builder: (context, state) {
        if (!(state is BluetoothDeviceConnectedState)) {
          _bloc().getInitState();
          return const IsNotBluetoothConnected(
              message: "No hay dispositivo conectado");
        }
        if (state is BluetoothDisconnectState) {
          return const IsNotBluetoothConnected(
            message: "No hay dispositivo conectado",
          );
        }
        return Scaffold(
            appBar: AppBar(),
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
                                  child: Text(data["bank_name"]!.toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: titleStyleText("", 16))),
                              const SizedBox(height: 4),
                              Text("(${data["bank_rif"]})",
                                  style: titleStyleText("", 16)),
                              const SizedBox(height: 4),
                              data["status"] == "APROBADO"
                                  ? Text("Recibo de compra".toUpperCase(),
                                      style: titleStyleText("", 16))
                                  : data["status"] == "ANULADO"
                                      ? Text("Anulación".toUpperCase(),
                                          style: titleStyleText("", 16))
                                      : Text("Recibo de compra".toUpperCase(),
                                          style: titleStyleText("", 16)),
                              const SizedBox(height: 4),
                              Text(data["card_name"]!,
                                  style: titleStyleText("", 16)),
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
                                    Text(data["name"]!.toUpperCase(),
                                        style: subtitleStyleText("", 16)),
                                    const SizedBox(height: 4),
                                    Text(data["address"]!.toUpperCase(),
                                        style: subtitleStyleText("", 16)),
                                    const SizedBox(height: 4),
                                    Row(children: [
                                      Text("RIF: ${data["rif"]}",
                                          style: subtitleStyleText("", 16)),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                          "Afiliado: ${data["affiliation_number"]}"
                                              .toUpperCase(),
                                          style: subtitleStyleText("", 16))
                                    ]),
                                    const SizedBox(height: 4),
                                    Row(children: [
                                      Text(
                                          "TERMINAL: ${data["terminal"]}"
                                              .toUpperCase(),
                                          style: subtitleStyleText("", 16)),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      Text("LOTE: ${data["lote"]}",
                                          style: subtitleStyleText("", 16))
                                    ]),
                                    const SizedBox(height: 4),
                                    Text(data["card_mask"]!,
                                        style: titleStyleText("", 16)),
                                    const SizedBox(height: 4),
                                    Row(children: [
                                      Text(
                                          "fecha: ${data["fecha"]}"
                                              .toUpperCase(),
                                          style: subtitleStyleText("", 16)),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                          "hora: ${data["hora"]}".toUpperCase(),
                                          style: subtitleStyleText("", 16))
                                    ]),
                                    data["status"] == "APROBADO" ||
                                            data["status"] == "ANULADO"
                                        ? Row(
                                            children: [
                                              Text("APROB: ${data["approval"]}",
                                                  style: subtitleStyleText(
                                                      "", 16)),
                                              const SizedBox(
                                                width: 6,
                                              ),
                                              Text("REF: ${data["reference"]}",
                                                  style: subtitleStyleText(
                                                      "", 16)),
                                              const SizedBox(
                                                width: 6,
                                              ),
                                              Text(
                                                  "TRACE: ${data["sequence"].toString()}",
                                                  style: subtitleStyleText(
                                                      "", 16)),
                                              const SizedBox(
                                                width: 6,
                                              ),
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              Text("REF: ${data["reference"]}",
                                                  style: subtitleStyleText(
                                                      "", 16)),
                                              const SizedBox(
                                                width: 6,
                                              ),
                                              Text(
                                                  "TRACE: ${data["sequence"].toString()}",
                                                  style: subtitleStyleText(
                                                      "", 16)),
                                              const SizedBox(
                                                width: 6,
                                              ),
                                            ],
                                          ),
                                  ]),
                            ]))
                  ])
                ]),
                data["status"] == "APROBADO" || data["status"] == "ANULADO"
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                            Center(
                                child: Text("**DUPLICADO**",
                                    style: subtitleStyleText("", 16))),
                            Center(
                                child: Text("O",
                                    style: subtitleStyleText("", 16))),
                            Center(
                                child: Text("COPIA DEL CLIENTE",
                                    style: subtitleStyleText("", 16))),
                          ])
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                            Center(
                                child: Text(data["status"]!,
                                    style: subtitleStyleText("", 16))),
                            const SizedBox(height: 5),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  data["response_code"] != null
                                      ? Center(
                                          child: Text(data["response_code"]!,
                                              style: titleStyleText("", 16)))
                                      : SizedBox(),
                                  SizedBox(width: 2),
                                  Center(
                                      child: Text(data["message"]!,
                                          style: titleStyleText("", 16))),
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
                              "${data["monto"]}",
                              style: titleStyleText("", 16),
                            ),
                          ])),
                  const SizedBox(height: 20),
                  data["status"] != "APROBADO"
                      ? SizedBox(height: 0)
                      : _accountType(accountType: data["payment_method"]),
                ]),
              ],
            ));
      },
    );
  }
}
