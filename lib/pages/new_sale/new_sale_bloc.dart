import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:optional/optional.dart';
import 'package:cliff_pickleball/domain/request/pin_pad_payment_request.dart';
import 'package:cliff_pickleball/pages/new_sale/presenter/input_amount_presenter.dart';
import 'package:cliff_pickleball/pages/new_sale/presenter/input_id_doc_presenter.dart';
import 'package:cliff_pickleball/pages/new_sale/presenter/input_pin_presenter.dart';
import 'package:cliff_pickleball/pages/new_sale/presenter/input_presenter.dart';
import 'package:cliff_pickleball/utils/tlv_comparator.dart';
import 'package:rxdart/rxdart.dart';

import '../../services/cacheService.dart';
import '../../services/http/result.dart';
import '../../utils/receipData.dart';
import 'new_sale_service.dart';
import 'qpos/payment_qpos_listener.dart';
import 'qpos/payment_qpos_service.dart';

part 'new_sale_event.dart';

part 'new_sale_state.dart';

@injectable
class NewSaleBloc extends Bloc<NewSaleEvent, NewSaleState>
    implements PaymentQposListener {
  final _logger = Logger();
  final _cache = Cache();
  final InputAmountPresenter _inputAmountPresenter;
  final InputIdDocPresenter _inputIdDocPresenter;
  final InputPinPresenter _inputPinPresenter;
  final NewSaleService _newSaleService;
  late PaymentQposService _qposService;

  final _displayController = BehaviorSubject.seeded("Inserte la tarjeta");

  Stream<String> get _displayStream => _displayController.stream;

  InputPresenter get pinPresenter => _inputPinPresenter;

  InputPresenter get idDocPresenter => _inputIdDocPresenter;

  InputPresenter get amountPresenter => _inputAmountPresenter;

  AccountType? _accountType;

  AidInfo? aidInfo;
  String? chip;

  bool isCancelable = true;
  bool isProcessing = false;

  NewSaleBloc(this._inputAmountPresenter, this._inputIdDocPresenter,
      this._inputPinPresenter, this._newSaleService)
      : super(const NewSaleInitialState()) {
    _qposService = PaymentQposService(this);
    _init();
    on<NewSaleEvent>((event, emit) {
      _logger.i("event ${event.runtimeType}");
      switch (event.runtimeType) {
        case NewSaleInitEvent:
          _init();
          emit(const InputAmountState());
          break;
        case InputIdDocEvent:
          emit(const InputIdDocState());
          break;
        case InputPinEvent:
          emit(const InputPinState());
          break;
        case ChooseAccountTypeEvent:
          emit(const ChooseAccountTypeState());
          break;
        case InsertCardEvent:
          emit(const InsertCardState());
          break;
        case ExitEvent:
          emit(const ExitState());
          break;
        case ProcessingPaymentEvent:
          emit(const ProcessingState());
          break;
        case ErrorEvent:
          var error = (event as ErrorEvent).error;
          emit(ErrorState(error));
          break;
        case PaymentSuccessEvent:
          var trx = (event as PaymentSuccessEvent).trx;
          Map<String, dynamic> map = jsonDecode(trx);
          var receipt = ReceiptData.getReceipt(map);
          emit(PaymentSuccessState(receipt));
          break;
      }
    });
  }

  void _init() {
    _displayController.value = "Inserte la tarjeta";
    isCancelable = true;
    isProcessing = false;
    _inputAmountPresenter.init();
    _inputIdDocPresenter.init();
    _inputPinPresenter.init();
    _qposService.init();
  }

  void _deleteCacheData() {
    _cache.deleteQposData();
  }

  Stream<String> displayMessageStream() {
    return _displayStream;
  }

  void setAccountType(AccountType accountType) {
    _accountType = accountType;
    _payment();
  }

  void _payment() async {
    var amount = double.parse(_inputAmountPresenter.amount()) / 100;
    var idDoc = _inputIdDocPresenter.idDoc();
    var deviceIdentifier =
        (await _cache.getDeviceInformation())?.device?.identifier;

    if (deviceIdentifier == null) {
      add(const ErrorEvent("DEVICE_IDENTIFIER_IS_NULL"));
    } else {
      isProcessing = true;
      add(const ProcessingPaymentEvent());
      var paymentCardType = Optional.ofNullable(aidInfo)
          .map((p0) => p0.type)
          .map((p0) => p0 == "TDD" ? PaymentCardType.TDD : PaymentCardType.TDC)
          .orElse(PaymentCardType.TDC);

      var accountType = _accountType ?? AccountType.CREDITO;
      if (paymentCardType == PaymentCardType.TDC) {
        accountType = AccountType.CREDITO;
      }
      var result = await _newSaleService
          .payment(deviceIdentifier, idDoc, amount, accountType,
              paymentCardType, chip!)
          .onError(Result.fail);
      isProcessing = false;
      isCancelable = false;

      var obj = result.obj;
      if (result.success) {
        if (obj != null) {
          add(PaymentSuccessEvent(obj));
        } else {
          error("EMPTY_RESPONSE");
        }
      } else {
        error(result.errorMessage);
      }
    }
  }

  @override
  void deviceDisconnected() {
    _deleteCacheData();
    add(const ExitEvent());
  }

  @override
  void enterCard() {
    add(const InsertCardEvent());
  }

  @override
  String getAmount() {
    return _inputAmountPresenter.amount();
  }

  @override
  void aidFound(AidInfo aidInfo) {
    this.aidInfo = aidInfo;
  }

  @override
  void error(String? error) {
    var str = error ?? "EMPTY_ERROR";
    add(ErrorEvent(str));
  }

  @override
  void requestPin() {
    add(const InputPinEvent());
  }

  void setPin() {
    _qposService.setPin(_inputPinPresenter.pin());
    add(const ProcessingPaymentEvent());
  }

  void startTrade() {
    _qposService.startDoTrade();
  }

  @override
  void display(String parameters) {
    _displayController.value = parameters;
  }

  @override
  void chipFound(String chip) {
    this.chip = chip;
  }

  @override
  void cardApproved() {
    if (aidInfo == null) {
      add(const ErrorEvent("AID_NOT_FOUND"));
    } else {
      if (aidInfo?.type == "TDD") {
        add(const ChooseAccountTypeEvent());
      } else {
        _payment();
      }
    }
  }

  @override
  Future<void> close() {
    _logger.i("CLOSE");
    cancelSubscription();
    return super.close();
  }

  void cancelSubscription() {
    _qposService.cancel();
  }

  void resetQPosStatus() {
    _qposService.resetQPosStatus();
  }
}
