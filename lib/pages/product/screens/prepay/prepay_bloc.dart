import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../services/cacheService.dart';
import '../../../../services/http/domain/productModel.dart';
import 'models/payment_model.dart';
part 'prepay_event.dart';
part 'prepay_state.dart';

class PrepayBloc extends Bloc<PrepayEvent, PrepayState> {
  final _logger = Logger();
  PaymentModel? payment = null;
  String? errorMessage = null;
  final _cache = Cache();



  PrepayBloc() : super(PrepayInitialState(payment: null)) {
    on<PrepayEvent>((event, emit) {
      switch(event.runtimeType){
        case PrepayInitialEvent:
          return PrepayInitialState(payment: payment, errorMessage: errorMessage);
        case PrepayLoadingEvent:
          return PrepayLoadingState(payment: payment, errorMessage: errorMessage);
        case PrepaySuccessEvent:
          return PrepaySuccessState(payment: payment, errorMessage: null);
        case PrepayErrorEvent:
          return PrepaySuccessState(payment: null, errorMessage: errorMessage);
      }
    });
  }

  String? _validateAmount(String? value) {
    if (value == null || value == "") {
      return "El monto no puede estar vacio";
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value == "") {
      return "El número de telefono no puede estar vacio";
    }
    return null;
  }

  Future<void> sendpayment(ProductModel product) async {
    var init = await _cache.getInitData("servicepay");

    Map<String, String> paramssend = {
      "business_id": init?.initData?.ally?.businessId ?? "",
      "user_id": init?.initData?.ally?.id ?? "",
      "user_email": init?.initData?.ally?.allyEmail ?? "",
      "country": "VE",
      "service_type": product.name ?? ""
    };
    var phone = "_phoneNumberController2";
    var amount = "_amountController2";
    var type = product.name ?? "";

    Map<String, String> bodysend = {
      "account_number": phone,
      "amount": amount,
      "payment_method": type
    };

  }


  @override
  Future<void> close() async {
    super.close();
  }
}
