part of 'pospay_bloc.dart';

@immutable
abstract class PospayEvent {
  const PospayEvent();
}

class PospayInitialEvent extends PospayEvent {
  const PospayInitialEvent();
}
class PospaySuccessEvent extends PospayEvent {
  const PospaySuccessEvent();
}
class PospayLoadingEvent extends PospayEvent {
  const PospayLoadingEvent();
}
class PospayLoadingPaymentEvent extends PospayEvent {
  const PospayLoadingPaymentEvent();
}
class PospayLoadedEvent extends PospayEvent {
  const PospayLoadedEvent();
}
class PospayErrorEvent extends PospayEvent {
  String? errorMessage;
  PospayErrorEvent({this.errorMessage});
}
