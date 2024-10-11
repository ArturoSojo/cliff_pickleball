part of 'pos_eq_bloc.dart';

abstract class PosEqEvent {
  const PosEqEvent();
}
class PosInitialEvent extends PosEqEvent {
  PosInitialEvent();
}
class PosLoadedProductEvent extends PosEqEvent {
  PosLoadedProductEvent();
}
class PosLoadingProductEvent extends PosEqEvent {
  PosLoadingProductEvent();
}
class PosErrorProductEvent extends PosEqEvent {
  PosErrorProductEvent();
}