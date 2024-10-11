part of 'sales_eq_bloc.dart';

abstract class SalesEqEvent {
  const SalesEqEvent();
}
class SalesInitialEvent extends SalesEqEvent {
  SalesInitialEvent();
}
class SalesLoadedProductEvent extends SalesEqEvent {
  SalesLoadedProductEvent();
}
class SalesLoadingProductEvent extends SalesEqEvent {
  SalesLoadingProductEvent();
}
class SalesErrorProductEvent extends SalesEqEvent {
  SalesErrorProductEvent();
}