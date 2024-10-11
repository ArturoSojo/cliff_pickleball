part of 'new_sale_bloc.dart';

@immutable
abstract class NewSaleState {
  const NewSaleState();
}

class NewSaleInitialState extends NewSaleState {
  const NewSaleInitialState();
}

class InputAmountState extends NewSaleState {
  const InputAmountState();
}

class InputIdDocState extends NewSaleState {
  const InputIdDocState();
}

class InputPinState extends NewSaleState {
  const InputPinState();
}

class ChooseAccountTypeState extends NewSaleState {
  const ChooseAccountTypeState();
}

class InsertCardState extends NewSaleState {
  const InsertCardState();
}

class ErrorState extends NewSaleState {
  final String error;
  const ErrorState(this.error);
}

class ExitState extends NewSaleState {
  const ExitState();
}

class ProcessingState extends NewSaleState {
  const ProcessingState();
}

class PaymentSuccessState extends NewSaleState {
  final dynamic trx;
  const PaymentSuccessState(this.trx);
}
