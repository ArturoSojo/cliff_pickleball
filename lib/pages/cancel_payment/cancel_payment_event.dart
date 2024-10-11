part of 'cancel_payment_bloc.dart';

@immutable
abstract class CancelPaymentEvent {
  const CancelPaymentEvent();
}

@immutable
class DisplayMessageEvent extends CancelPaymentEvent {
  final String msg;

  const DisplayMessageEvent(this.msg);
}

@immutable
class ErrorEvent extends CancelPaymentEvent {
  final String error;

  const ErrorEvent(this.error);
}

@immutable
class InputPinEvent extends CancelPaymentEvent {
  const InputPinEvent();
}

@immutable
class ProcessingPaymentEvent extends CancelPaymentEvent {
  const ProcessingPaymentEvent();
}

@immutable
class SuccessEvent extends CancelPaymentEvent {
  final String trx;

  const SuccessEvent(this.trx);
}

@immutable
class ChooseAccountTypeEvent extends CancelPaymentEvent {
  const ChooseAccountTypeEvent();
}
