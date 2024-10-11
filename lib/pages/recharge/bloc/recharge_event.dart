part of 'recharge_bloc.dart';

@immutable
abstract class RechargeEvent {}

class RechargeInitialEvent extends RechargeEvent {
  RechargeInitialEvent();
}
// class RechargeCleanEvent extends RechargeEvent {
//   RechargeCleanEvent();
// }
class RechargeLoadingEvent extends RechargeEvent {
  RechargeLoadingEvent();
}
class RechargeLoadedEvent extends RechargeEvent {
  RechargeLoadedEvent();
}
class RechargeSuccessEvent extends RechargeEvent {
  RechargeSuccessEvent();
}
class RechargeErrorEvent extends RechargeEvent {
  RechargeErrorEvent();
}
class RechargeErrorPaymentEvent extends RechargeEvent {
  RechargeErrorPaymentEvent();
}
