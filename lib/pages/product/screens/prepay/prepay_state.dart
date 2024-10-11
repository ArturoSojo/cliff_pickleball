part of 'prepay_bloc.dart';

@immutable
abstract class PrepayState {
  PaymentModel? payment = null;
  String? errorMessage = null;
  PrepayState({this.payment, this.errorMessage});
}

class PrepayInitialState extends PrepayState {
  PrepayInitialState({super.payment, super.errorMessage});
}
class PrepaySuccessState extends PrepayState {
  PrepaySuccessState({super.payment, super.errorMessage});
}
class PrepayLoadingState extends PrepayState {
  PrepayLoadingState({super.payment, super.errorMessage});
}
class PrepayErrorState extends PrepayState {
  PrepayErrorState({super.payment, super.errorMessage});
}
