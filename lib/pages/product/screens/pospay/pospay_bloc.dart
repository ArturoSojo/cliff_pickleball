import 'package:bloc/bloc.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:cliff_pickleball/pages/product/screens/pospay/pospay_service.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../services/http/domain/productModel.dart';
import '../../../../utils/translate.dart';
import '../prepay/models/payment_model.dart';
import 'models/account_model.dart';

part 'pospay_event.dart';
part 'pospay_state.dart';

class PospayBloc extends Bloc<PospayEvent, PospayState> {
  PospayBloc() : super(PospayInitialState()) {
    on<PospayEvent>((event, emit) {
      _logger.i(event);

      switch (event.runtimeType) {
        case PospayInitialEvent:
          emit(PospayInitialState(payment: payment, account: maccount));
          break;
        case PospayLoadingEvent:
          emit(PospayLoadingState(payment: payment, account: maccount));
          break;
        case PospayLoadingPaymentEvent:
          emit(PospayLoadingPaymentState(payment: payment, account: maccount));
          break;
        case PospayErrorEvent:
          emit(PospayErrorState(errorMessage: errorMessage, account: maccount));
          break;
        case PospaySuccessEvent:
          emit(PospaySuccessState(payment: payment, account: maccount));
          break;
        case PospayLoadedEvent:
          emit(PospayLoadedState(payment: payment, account: maccount));
          break;
      }
    });
  }

  final _logger = Logger();
  PaymentModel? payment;
  AccountModel? maccount;
  String? errorMessage;
  double? debt;
  bool isTotal = true;
  TextEditingController controllerContract = TextEditingController();
  TextEditingController amountController = TextEditingController();
  var numFormat =
      CurrencyTextInputFormatter(locale: 'es_VE', decimalDigits: 2, symbol: "");
  var currency = 'VE';

  void setDebt(double? debtParam) {
    debt = debtParam;
    numFormat.format(debtParam.toString());
    add(PospayLoadedEvent());
  }

  void setTotal(bool total, {double? value}) {
    _logger.i(value);
    isTotal = total;
    if (isTotal) {
      debt = value;
      numFormat.format(value.toString());
      amountController.text = value.toString();
    } else {
      debt = null;
      numFormat.format("");
      amountController.text = "";
    }
    add(PospayLoadedEvent());
  }

  void setAmount(price) {
    if (price != null && price.trim() != "") {
      add(PospayLoadedEvent());
    }
  }

  void clean() {
    payment = null;
    maccount = null;
    errorMessage = null;
    debt = null;
    controllerContract.text = "";
    amountController.text = "";
    add(PospayInitialEvent());
  }

  void clean2() {
    payment = null;
    maccount = null;
    errorMessage = null;
    debt = null;
    amountController.text = "";
  }

  String? accountValidate(value, String type) {
    if (value.isEmpty || value.trim() == "") {
      return "El número de $type no puede estar vacio";
    }
    if (value.length < 6) {
      return "El  número de $type debe ser mayor o igual a 6 digitos";
    }
    return null;
  }

  String? amountValidate(price, double total) {
    if (price == null || price.isEmpty) {
      return 'El monto no puede estar vacio';
    }
    _logger.i(numFormat.getUnformattedValue());

    // if(numFormat.getUnformattedValue() < 1.0){
    //   return 'El monto ingresado no puede ser menor a Bs. 1.00';
    // }

    return null;
  }

  Future<void> getAccount(
      {required ProductModel product, bool fix = false}) async {
    amountController.text = "";
    add(PospayLoadingEvent());

    var result = await getResponsePos(product, controllerContract.text, fix);
    if (result.success) {
      if (result.obj != null) {
        maccount = result.obj;
        if (product.company == "CANTV") {
          setDebt(maccount?.expiredDebt);
        } else {
          setTotal(isTotal, value: maccount?.balance);
        }
      }
    } else {
      errorMessage =
          translate(result.errorMessage ?? "Error al consultar el producto");
      _logger.i(result.error.toString());
      add(PospayErrorEvent(errorMessage: errorMessage));
    }
  }

  Future<void> sendpayment(ProductModel product, String payment_method) async {
    if (controllerContract.text != "") {
      var formattedDebt = debt != null
          ? double.parse((debt!.toStringAsFixed(2)))
          : numFormat.getUnformattedValue().toDouble();
      if (formattedDebt != null) {
        //if(formattedDebt>=1){
        add(PospayLoadingPaymentEvent());
        var result = await sendPaymentPospay(
            product: product,
            acc: controllerContract.text,
            debt: formattedDebt,
            payment_method: payment_method);
        if (result.success) {
          if (result.obj != null) {
            payment = result.obj;
            add(PospaySuccessEvent());
          }
        } else {
          clean2();
          errorMessage =
              translate(result.errorMessage ?? "Error al realizar el pago");
          add(PospayErrorEvent(errorMessage: errorMessage));
        }
        //}
      }
    }
  }

  @override
  Future<void> close() async {
    super.close();
  }
}
