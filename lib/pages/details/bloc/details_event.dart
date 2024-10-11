part of 'details_bloc.dart';

@immutable
abstract class DetailsEvent {
  DetailsEvent();
}
class DetailsInitialEvent extends DetailsEvent{
   DetailsInitialEvent();
}
class DetailsLoadingEvent extends DetailsEvent {
  DetailsLoadingEvent();
}
class DetailsSuccessEvent extends DetailsEvent {
   DetailsSuccessEvent();
}
class DetailsLoadedEvent extends DetailsEvent {
   DetailsLoadedEvent();
}
class DetailsErrorEvent extends DetailsEvent {
   DetailsErrorEvent();
}
class DetailsErrorNotListEvent extends DetailsEvent {
  DetailsErrorNotListEvent();
}