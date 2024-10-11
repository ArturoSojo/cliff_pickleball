import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../services/http/domain/productModel.dart';
import '../../../../styles/text.dart';
import '../../../../widgets/rich_text.dart';
import '../prepay/models/payment_model.dart';


class Voucher extends StatelessWidget {
  PaymentModel payment;
  ProductModel product;
  final Uri movistarUrl = Uri.parse('www.movistar.com.ve');
  Voucher({Key? key, required this.payment, required this.product}) : super(key: key);

  launchMovistarUrl() async {
    if(!await launchUrl(movistarUrl)){
      throw Exception('No puede navegar a la página $movistarUrl');
    }
  }



  Widget _header(){
    var company = product.company?.toLowerCase();
    List<String> listCompanies = ["movistar", "digitel", "simpletv", "cantv", "movilnet"];
    int isExistsImage = listCompanies.indexOf(company ?? "");
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isExistsImage != -1 ?
              Image.asset("assets/img/$company.png", width: 150, height: 80):
              Image.asset("assets/img/not_found.png", width: 80, height: 40)
            ],
          ),
          const SizedBox(height: 5),
          Column(children: const [
             Center(child: Text("PAGUETODO", style: TitleTextStyle(fontSize: 16))),
             Center(child: Text("FÁCIL Y SEGURO", style: TitleTextStyle(fontSize: 16))),
             Center(child: Text("RIF: J-40339964-6", style: TitleTextStyle(fontSize: 16))),
            ])
          ],
        ),
      );
    }

    Widget _body(){
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            MRichText.rich(title: "Nro: ", text: payment.sequence.toString()),
            MRichText.rich(title: "Fecha: ", text: payment.formattedCreatedAt ?? ""),
            MRichText.rich(title: "Operador: ", text: payment.createdByEmail ?? ""),
            MRichText.rich(title: "Empresa: ", text: product.company ?? ""),
            MRichText.rich(title: "Servicio: ", text: payment.formattedService ?? ""),
            const SizedBox(height: 20),
            MRichText.rich(title: "Cuenta: ", text: payment.accountNumber ?? ""),
            MRichText.rich(title: "Monto: ", text: "${payment.formattedAmount} bs"),
            MRichText.rich(title: "Nro. aprobación: ", text: payment.approvedNumber ?? ""),
            const SizedBox(height: 20),
            MRichText.rich(title: "Total a pagar: ", text: "${payment.formattedAmount} bs"),
            MRichText.rich(title: "Status: ", text: payment.formattedStatus ?? ""),

          ],
        ),
      );
    }

    Widget _movistarDescription() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Center(child: Text("Tu número ha sido recargado", style: TextStyle(fontSize: 12),)),
          const Center(child: Text("Consulta el saldo marcando *88 o *144#", style: TextStyle(fontSize: 12),)),
          const Center(child: Text("Consulta nuestros planes y servicios", style: TextStyle(fontSize: 12),)),
          const Center(child: Text("llamando al 811 desde tu Movistar o visita ", style: TextStyle(fontSize: 12),)),
          Center(child: InkWell(
            onTap: () => launchUrl(movistarUrl),
            child: Text("www.movistar.com.ve", style: TextStyle(fontSize: 12,color: Color.fromARGB(255, 37, 33, 243)),),
          )),
        ],
      );
    }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Card(
        borderOnForeground: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _header(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Center(child: Text("RECIBO DE COMPRA", style: TitleTextStyle(fontSize: 14, fontWeight: FontWeight.bold)))
              ],
            ),
            _body(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Center(child: Text("COPIA", style: TitleTextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
              ],
            ),
             product.company == "MOVISTAR" ? _movistarDescription() : SizedBox(),
          ],
        ),
      ),
    );
  }
}
