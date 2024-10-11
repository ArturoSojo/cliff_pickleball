import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cliff_pickleball/pages/product/screens/pospay/pospay_bloc.dart';
import 'package:cliff_pickleball/pages/product/screens/pospay/pospay_screen.dart';
import 'package:cliff_pickleball/pages/product/screens/prepay/prepay_screen.dart';
import 'package:cliff_pickleball/services/http/domain/productModel.dart';

import '../../domain/device.dart';
import '../../services/cacheService.dart';
import '../../styles/text.dart';

class NewSalesProduct extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final ProductModel product;
  const NewSalesProduct({super.key, required this.product});
  @override
  // ignore: library_private_types_in_public_api
  _NewSalesProductState createState() => _NewSalesProductState();
}

class _NewSalesProductState extends State<NewSalesProduct> {
  Widget _showErrorMessage(
      {String errorMessage = "NO HAY SERVICIOS DISPONIBLES"}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: LottieBuilder.asset(
            "assets/img/warning.json",
            repeat: false,
            width: 100,
            height: 100,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          errorMessage,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var category = widget.product.category;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(category!),
        ),
      ),
      body: category == "RECARGA"
          ? Prepay(product: widget.product)
          : category == "POSPAGO"
              ? Pospay(product: widget.product, bloc: PospayBloc())
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: _showErrorMessage(errorMessage: "SERVICIO INVÁLIDO"),
                  ),
                ),
    );
  }
}
