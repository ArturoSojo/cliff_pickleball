part of 'prepay_bloc.dart';

@immutable
abstract class PrepayEvent {
  PrepayEvent();
}

class PrepayInitialEvent extends PrepayEvent {
  PrepayInitialEvent();
}
class PrepaySuccessEvent extends PrepayEvent {
  PrepaySuccessEvent();
}
class PrepayLoadingEvent extends PrepayEvent {
  PrepayLoadingEvent();
}
class PrepayErrorEvent extends PrepayEvent {
  PrepayErrorEvent();
}
