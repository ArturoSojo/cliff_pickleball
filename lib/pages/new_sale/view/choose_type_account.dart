import 'package:flutter/material.dart';
import 'package:cliff_pickleball/domain/request/pin_pad_payment_request.dart';

import '../../../styles/text.dart';

class ChooseTypeAccountScreen extends StatelessWidget {
  final Function(AccountType) next;

  const ChooseTypeAccountScreen(this.next, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Center(
              child: Text("TIPO DE CUENTA", style: subtitleStyleText("", 14))),
        ),
        const SizedBox(height: 10),
        accountType(AccountType.PRINCIPAL, next),
        accountType(AccountType.AHORRO, next),
        accountType(AccountType.CORRIENTE, next)
      ],
    );
  }

  Widget accountType(AccountType accountType, Function(AccountType) f) {
    return InkWell(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(accountType.name, style: titleStyleText("", 15)),
                          Text(
                              "Tipo de cuenta ${accountType.name}"
                                  .toUpperCase(),
                              style: subtitleStyleText("", 12))
                        ],
                      ),
                    ],
                  ),
                  const Icon(Icons.arrow_forward_ios)
                ])),
        onTap: () => f(accountType));
  }
}
