import "package:flutter/material.dart";

import '../widgets/credit_receipt.dart';

class Receipt extends StatefulWidget {
  final Map data;

  const Receipt({super.key, required this.data});

  @override
  State<Receipt> createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onHorizontalDragUpdate: (updateDetails) {},
        child: Scaffold(body: CreditReceipt(data: widget.data)));
  }
}
