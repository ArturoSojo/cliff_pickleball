import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:cliff_pickleball/pages/cancel_payment/domain/operation.dart';
import 'package:cliff_pickleball/pages/new_sale/qpos/payment_qpos_service.dart';
import 'package:cliff_pickleball/utils/tlv_comparator.dart';

import '../../domain/request/pin_pad_payment_request.dart';
import '../../services/http/result.dart';
import '../../utils/receipData.dart';
import '../new_sale/presenter/input_pin_presenter.dart';
import '../new_sale/presenter/input_presenter.dart';
import '../new_sale/qpos/payment_qpos_listener.dart';
import 'cancel_payment_service.dart';

part 'cancel_payment_event.dart';
part 'cancel_payment_state.dart';

@injectable
class CancelPaymentBloc extends Bloc<CancelPaymentEvent, CancelPaymentState>
    with PaymentQposListener {
  final _logger = Logger();
  late Operation _operation;

  AidInfo? aidInfo;
  String? chip;
  AccountType? _accountType;

  late PaymentQposService _qposService;

  final InputPinPresenter _inputPinPresenter;
  final CancelPaymentService _cancelPaymentService;

  InputPresenter get pinPresenter => _inputPinPresenter;

  CancelPaymentBloc(this._inputPinPresenter, this._cancelPaymentService)
      : super(const CancelPaymentInitial()) {
    _qposService = PaymentQposService(this);
    on<CancelPaymentEvent>((event, emit) {
      _logger.i("event ${event.runtimeType}");
      switch (event.runtimeType) {
        case DisplayMessageEvent:
          emit(DisplayMessageState((event as DisplayMessageEvent).msg));
          break;
        case ErrorEvent:
          emit(ErrorState((event as ErrorEvent).error));
          break;
        case InputPinEvent:
          emit(const InputPinState());
          break;
        case ChooseAccountTypeEvent:
          emit(const ChooseAccountTypeState());
          break;
        case ProcessingPaymentEvent:
          emit(const ProcessingState());
          break;
        case SuccessEvent:
          var trx = (event as SuccessEvent).trx;
          Map<String, dynamic> map = jsonDecode(trx);
          var receipt = ReceiptData.getReceipt(map);
          emit(SuccessState(receipt));
          break;
      }
    });
  }

  void clear() {
    _qposService.cancel();
  }

  void init(Operation operation) {
    _operation = operation;
    _qposService.init();
    _inputPinPresenter.init();
    _qposService.startDoTrade();
  }

  void setPin() {
    _qposService.setPin(_inputPinPresenter.pin());
  }

  void _annul() async {
    add(const ProcessingPaymentEvent());

    var result = await _cancelPaymentService
        .annul(_operation.id, _operation.cardHolderId, _operation.accountType,
            chip!)
        .onError(Result.fail);

    var obj = result.obj;
    if (result.success) {
      if (obj != null) {
        add(SuccessEvent(obj));
      } else {
        error("EMPTY_RESPONSE");
      }
    } else {
      error(result.errorMessage);
    }
  }

  @override
  void aidFound(AidInfo aidInfo) {
    this.aidInfo = aidInfo;
  }

  @override
  void cardApproved() {
    _logger.i("cardApproved called");
    if (aidInfo == null) {
      add(const ErrorEvent("AID_NOT_FOUND"));
    } else {
      _annul();
    }
  }

  @override
  void chipFound(String chip) {
    this.chip = chip;
  }

  @override
  void deviceDisconnected() {
    // TODO: implement deviceDisconnected
  }

  @override
  void display(String parameters) {
    add(DisplayMessageEvent(parameters));
  }

  @override
  void enterCard() {
    add(const DisplayMessageEvent("Inserte la tarjeta"));
  }

  @override
  void error(String? parameters) {
    add(ErrorEvent(parameters ?? "ERROR"));
  }

  @override
  String getAmount() {
    return _operation.amount;
  }

  @override
  void requestPin() {
    add(const InputPinEvent());
  }

  void setAccountType(AccountType accountType) {
    _accountType = accountType;
    _annul();
  }

  void cancelSubscription() {
    _qposService.cancel();
  }
}
