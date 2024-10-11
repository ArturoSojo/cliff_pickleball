part of 'pospay_bloc.dart';

@immutable
abstract class PospayState {
  PaymentModel? payment;
  AccountModel? account;
  PospayState({this.account, this.payment});
}

class PospayInitialState extends PospayState {
  PospayInitialState({super.payment, super.account});
}
class PospayLoadedState extends PospayState {
  PospayLoadedState({super.payment, super.account});
}
class PospaySuccessState extends PospayState {
  PospaySuccessState({super.payment, super.account});
}
class PospayLoadingPaymentState extends PospayState {
  PospayLoadingPaymentState({super.payment, super.account});
}
class PospayLoadingState extends PospayState {
  PospayLoadingState({super.payment, super.account});
}
class PospayErrorState extends PospayState {
  String? errorMessage;
  PospayErrorState({this.errorMessage, super.account});
}