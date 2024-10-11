part of 'cancel_payment_bloc.dart';

@immutable
abstract class CancelPaymentState {
  const CancelPaymentState();
}

class CancelPaymentInitial extends CancelPaymentState {
  const CancelPaymentInitial();
}


class DisplayMessageState extends CancelPaymentState {
  final String msg;

  const DisplayMessageState(this.msg);
}

class ErrorState extends CancelPaymentState {
  final String error;

  const ErrorState(this.error);
}

class InputPinState extends CancelPaymentState {
  const InputPinState();
}

class ChooseAccountTypeState extends CancelPaymentState {
  const ChooseAccountTypeState();
}

class ProcessingState extends CancelPaymentState {
  const ProcessingState();
}

class SuccessState extends CancelPaymentState {
  final Map<String, dynamic> trx;
  const SuccessState(this.trx);
}