import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:cliff_pickleball/pages/cancel_payment/cancel_payment_bloc.dart';
import 'package:cliff_pickleball/styles/bg.dart';
import 'package:cliff_pickleball/utils/translate.dart';

import '../../domain/request/pin_pad_payment_request.dart';
import '../../styles/text.dart';
import '../anulated_receipt.dart';
import '../new_sale/view/choose_type_account.dart';
import '../new_sale/view/error.dart';
import '../new_sale/view/input_screen.dart';
import 'domain/operation.dart';

class CancelPaymentScreen extends StatefulWidget {
  final NumberFormat _formatter = NumberFormat.currency(
      locale: "es_VE",
      name: "VED",
      symbol: "Bs.",
      decimalDigits: 2,
      customPattern: "¤#,##0.00;¤-#,##0.00");

  final Operation operation;

  String get amountFormatted =>
      _formatter.format((int.parse(operation.amount) / 100));

  CancelPaymentScreen(this.operation, {Key? key}) : super(key: key);

  @override
  State<CancelPaymentScreen> createState() => _CancelPaymentScreenState();
}

class _CancelPaymentScreenState extends State<CancelPaymentScreen> {
  final _logger = Logger();

  @override
  void initState() {
    super.initState();
    _logger.i("amount ${widget.operation.amount}");
    _bloc().init(widget.operation);
  }

  CancelPaymentBloc _bloc() {
    return context.read<CancelPaymentBloc>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var textScale = MediaQuery.of(context).textScaleFactor;
    return BlocConsumer<CancelPaymentBloc, CancelPaymentState>(
        listener: (context, state) {},
        builder: (context, state) {
          _logger.i("builder $state");
          switch (state.runtimeType) {
            case InputPinState:
              return Center(
                child: SingleChildScrollView(
                  child: InputScreen("PIN", "SIGUIENTE", _bloc().pinPresenter,
                      () => _bloc().setPin()),
                ),
              );
            case ErrorState:
              var error = (state as ErrorState).error;
              return ErrorView(error);
            case ChooseAccountTypeState:
              return SafeArea(child: ChooseTypeAccountScreen(_addAccountType));
            case SuccessState:
              return AnulatedReceipt((state as SuccessState).trx);
          }

          return Scaffold(
              body: GestureDetector(
            onHorizontalDragUpdate: (updateDetails) {},
            child: Container(
              color: ColorUtil.primaryColor(),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(height: 100),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(widget.amountFormatted,
                                      style: titleStyleText(
                                          "white", 40 * textScale)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(widget.operation.cardHolderId,
                                      //"${d["card_holder_id"].replaceAll(RegExp(r'^0+(?=.)'), '')}",
                                      style: subtitleStyleText(
                                          "white", 30 * textScale))
                                ],
                              ),
                            ])),
                    LottieBuilder.asset("assets/img/insert-card-2.json"),
                    displayMsg(state),
                    const SizedBox(height: 10)
                  ]),
            ),
          ));
        });
  }

  Widget displayMsg(CancelPaymentState state) {
    if (state is DisplayMessageState && state.msg.isNotEmpty) {
      return Text(translate(state.msg), style: subtitleStyleText("white", 14));
    }

    if (state is ProcessingState) {
      return const CircularProgressIndicator();
    }

    return const SizedBox();
  }

  void _addAccountType(AccountType accountType) {
    _bloc().setAccountType(accountType);
  }

  @override
  void deactivate() {
    _bloc().cancelSubscription();
    super.deactivate();
  }
}
