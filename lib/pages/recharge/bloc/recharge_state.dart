part of 'recharge_bloc.dart';

@immutable
abstract class RechargeState {

}

class RechargeInitialState extends RechargeState {
  RechargeInitialState();
}
class RechargeLoadingState extends RechargeState {
  RechargeLoadingState();
}
class RechargeSuccessState extends RechargeState {
  RechargeSuccessState();
}
class RechargeCleanState extends RechargeState {
  RechargeCleanState();
}
class RechargeLoadedState extends RechargeState {
  RechargeLoadedState();
}
class RechargeErrorState extends RechargeState {
  String errorMessage;
  RechargeErrorState({required this.errorMessage});
}
class RechargeErrorPaymentState extends RechargeState {
  String errorMessage;
  RechargeErrorPaymentState({required this.errorMessage});
}
