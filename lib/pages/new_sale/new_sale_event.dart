part of 'new_sale_bloc.dart';

@immutable
abstract class NewSaleEvent {
  const NewSaleEvent();
}

class InputIdDocEvent extends NewSaleEvent {
  const InputIdDocEvent();
}

class InputPinEvent extends NewSaleEvent {
  const InputPinEvent();
}

class ChooseAccountTypeEvent extends NewSaleEvent {
  const ChooseAccountTypeEvent();
}

class InsertCardEvent extends NewSaleEvent {
  const InsertCardEvent();
}

class ExitEvent extends NewSaleEvent {
  const ExitEvent();
}

class NewSaleInitEvent extends NewSaleEvent {
  const NewSaleInitEvent();
}

class ErrorEvent extends NewSaleEvent {
  final String error;

  const ErrorEvent(this.error);
}

class ProcessingPaymentEvent extends NewSaleEvent {
  const ProcessingPaymentEvent();
}

class PaymentSuccessEvent extends NewSaleEvent {
  final String trx;
  const PaymentSuccessEvent(this.trx);
}
