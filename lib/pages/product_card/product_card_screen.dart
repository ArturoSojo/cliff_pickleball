import 'package:flutter/material.dart';
import 'package:cliff_pickleball/services/http/domain/productModel.dart';

class ProductCardRecharge extends StatefulWidget {
  final ProductModel product;
  const ProductCardRecharge({super.key, required this.product});
  @override
  // ignore: library_private_types_in_public_api
  _ProductCardRechargeState createState() => _ProductCardRechargeState();
}

class _ProductCardRechargeState extends State<ProductCardRecharge> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("CENTRADO"),
      ),
    );
  }
}
