part of 'store_bloc.dart';

@immutable
abstract class StoreState {
  InventoryModel? inventory;
  Results? consigned;
  List<String>? listTypes = [];
  StoreState({this.inventory, this.consigned, this.listTypes});
}
// ignore: must_be_immutable
class StoreInitialState extends StoreState {
  StoreInitialState({super.inventory, super.consigned, super.listTypes});
}
// ignore: must_be_immutable
class StoreLoadingState extends StoreState {
  StoreLoadingState({super.inventory, super.consigned, super.listTypes});
}
// ignore: must_be_immutable
class StoreSuccessState extends StoreState {
  StoreSuccessState({super.inventory, super.consigned, super.listTypes});
}
// ignore: must_be_immutable
class StoreLoadedState extends StoreState {
  StoreLoadedState({super.inventory, super.consigned, super.listTypes});
}
// ignore: must_be_immutable
class StoreErrorState extends StoreState {
  String errorMessage;
  StoreErrorState({required this.errorMessage});
}
// ignore: must_be_immutable
class StoreGoNextState extends StoreState {
  String next;
  Results? product;
  StoreGoNextState({required this.next, this.product, super.listTypes});
}
