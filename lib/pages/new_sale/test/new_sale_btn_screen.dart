import 'package:flutter/material.dart';

import '../view/new_sale_screen.dart';

class NewSaleBtnScreen extends StatefulWidget {
  const NewSaleBtnScreen({Key? key}) : super(key: key);

  @override
  State<NewSaleBtnScreen> createState() => _NewSaleBtnScreenState();
}

class _NewSaleBtnScreenState extends State<NewSaleBtnScreen> {
  @override
  void initState() {
    super.initState();
  }

  void next() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NewSaleScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: next, child: const Text("Pago"));
  }
}
