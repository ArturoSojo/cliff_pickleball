import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:meta/meta.dart';
import 'package:logger/logger.dart';
import 'package:cliff_pickleball/pages/recharge/bloc/recharge_service.dart';

import '../../../utils/translate.dart';
import '../../store/models/collect_channel_model.dart';

part 'recharge_event.dart';
part 'recharge_state.dart';

class RechargeBloc extends Bloc<RechargeEvent, RechargeState> {
  List<String> listTypes;
  final Logger _logger = Logger();
  RechargeBloc({required this.listTypes}) : super(RechargeInitialState()) {
    on<RechargeEvent>((event, emit) {
      _logger.i(event);
      switch (event.runtimeType) {
        case RechargeInitialEvent:
          emit(RechargeInitialState());
          break;
        case RechargeSuccessEvent:
          emit(RechargeSuccessState());
          break;
        case RechargeLoadingEvent:
          emit(RechargeLoadingState());
          break;
        case RechargeLoadedEvent:
          emit(RechargeLoadedState());
          break;
        case RechargeErrorEvent:
          emit(RechargeErrorState(errorMessage: errorMessage!));
          break;
        case RechargeErrorPaymentEvent:
          emit(RechargeErrorPaymentState(errorMessage: errorMessage!));
          break;
      }
    });
  }

  final dateFormat = DateFormat(
    'dd/MM/y',
  );
  final dateFormat2 = DateFormat(
    'y-MM-dd',
  );
  var maskFormatter = MaskTextInputFormatter(
      mask: '###-####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  var numFormat =
      CurrencyTextInputFormatter(locale: 'es_VE', decimalDigits: 2, symbol: "");

  String? errorMessage;

  TextEditingController numberController = TextEditingController();
  TextEditingController dniController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController referenceController = TextEditingController();

  List<String> types_docs = ["V", "E", "J", "P"];
  List<String> types_phones = ["412", "414", "416", "424", "426"];
  List<String> types_service =
      ["PREPAY", "POSTPAID"].map((e) => translate(e)).toList();

  void setTypeService(String? type) {
    typeServiceSelected = type ?? listTypes[0];
    add(RechargeLoadedEvent());
  }

  List<CollectMethods>? banks;
  CollectMethods? bankSelected;
  String? typeDniSelected;
  String? typePhoneSelected;
  String? typeServiceSelected;
  double rate = 1.0;
  String? formattedRate;
  String? showRate;

  void setBank(CollectMethods? bank) {
    bankSelected = bank ?? banks![0];
    add(RechargeLoadedEvent());
  }

  void setTypePhone(String? type) {
    typePhoneSelected = type ?? types_phones[0];
    add(RechargeLoadedEvent());
  }

  void setTypeDoc(String? type) {
    typeDniSelected = type ?? types_docs[0];
    add(RechargeLoadedEvent());
  }

  void setInit() async {
    typeDniSelected = types_docs[0];
    typePhoneSelected = types_phones[0];
    typeServiceSelected = listTypes[0];
    await _gBanks();
  }

  void setAmount(amount) {
    if (amount != null && amount.trim() != "") {
      amountController.value = TextEditingValue(
        text: amount,
        selection: TextSelection.collapsed(offset: amount.length),
      );
    }
  }

  String? validateBank(CollectMethods? bank) {
    if (bank == null) {
      return 'Seleccione un banco pagador';
    }
    return null;
  }

  String? validateNumber(phone) {
    var t = r'[0-9]{3}\-[0-9]{4}';
    if (phone == null || phone.isEmpty) {
      return 'El número de teléfono no puede estar vacio';
    }
    String pattern = t;
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(phone)) {
      return 'Ingrese un número de teléfono válido';
    } else {
      return null;
    }
  }

  // String? validateDate(date){
  //   return null;
  // }
  String? validateAmount(amount) {
    if (amount == null || amount.isEmpty) {
      return "El monto no puede estar vacio";
    }

    // if(numFormat.getUnformattedValue() < rate){
    //   return "El monto minimo es ${formattedRate} equivalente a 10\$";
    // }
    return null;
  }

  String? validateDni(digits) {
    if (digits == null || digits.isEmpty) {
      return 'La cédula no puede estar vacia';
    }
    if (digits.length < 4) {
      return 'Ingrese una cédula válida';
    }
    return null;
  }

  String? validateTypeDni(type) {
    if (type == null || type.isEmpty) {
      return 'Seleccione un tipo de cédula';
    }
    return null;
  }

  String? validateTypePhone(type) {
    if (type == null || type.isEmpty) {
      return 'Seleccione un tipo de operador';
    }
    return null;
  }

  String? validateTypeService(type) {
    if (type == null || type.isEmpty) {
      return 'Seleccione un tipo de servicio';
    }
    return null;
  }

  String? validateReference(reference) {
    if (reference == null || reference.isEmpty) {
      return 'La referencia no puede estar vacia';
    }
    if (reference.length < 6) {
      return 'Ingrese una referencia válida';
    }
    return null;
  }

  void clean() {
    bankSelected = banks![0];
    typeDniSelected = types_docs[0];
    typePhoneSelected = types_phones[0];
    typeServiceSelected = listTypes[0];
    referenceController.text = "";
    numberController.text = "";
    dniController.text = "";
    amountController.text = "";
    add(RechargeLoadedEvent());
  }

  Future<void> _gBanks() async {
    var result = await getBanks();
    if (result.success) {
      if (result.obj != null) {
        print("METODOSSSS");

        var collecMethods = result.obj?.collectMethods ?? [];
        print(collecMethods[0].productName);
        print(collecMethods[1].productName);
        if (collecMethods.isNotEmpty) {
          banks = collecMethods
              .where((x) => x.productName == "MOBILE_PAYMENT_SEARCH_API")
              .toList();
          if (banks == null || (banks?.isEmpty ?? true)) {
            errorMessage = result.errorMessage ??
                "No se han encontrado métodos para recargar el inventario";
            add(RechargeErrorEvent());
          }
          bankSelected = banks![0];
          add(RechargeLoadedEvent());
          //await _getCurrencyRate();
          return;
        }
      }
    }
    errorMessage =
        result.errorMessage ?? "Error al obtener los metodos de colección";
    add(RechargeErrorEvent());
  }

  Future<void> sendRechage() async {
    add(RechargeLoadingEvent());

    var phone =
        '$typePhoneSelected${maskFormatter.unmaskText(numberController.text)}';
    var dni = "$typeDniSelected${dniController.text.padLeft(9, "0")}";
    var inventoryType = "$typeServiceSelected";
    var reference = referenceController.text;
    var productName = bankSelected?.productName ?? "";
    var collectMethodId = bankSelected?.id ?? "";
    var code = bankSelected?.bankInfo?.code ?? "";
    var result = await rechargePayment(
        payerBankCode: code,
        product_name: productName,
        collect_method_id: collectMethodId,
        inventory_type: inventoryType,
        phone: phone,
        dni: dni,
        amount: numFormat.getUnformattedValue(),
        reference: reference);

    if (result.success) {
      add(RechargeSuccessEvent());
    } else {
      errorMessage = result.errorMessage ?? "Error al realizar el pago";
      add(RechargeErrorPaymentEvent());
    }
  }
}
