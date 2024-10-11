part of 'pos_eq_bloc.dart';

abstract class PosEqState extends Equatable {
  List<View>? views = [];
  Profile? profile = null;
  PosEqState({this.views, this.profile});

  @override
  List<Object?> get props => [];
}
class PosInitialState extends PosEqState {
  PosInitialState({super.views, super.profile});
}
class PosLoadingProductState extends PosEqState {
  PosLoadingProductState();
}
class PosLoadedProductState extends PosEqState {
  PosLoadedProductState({super.views, super.profile});
}
class PosErrorProductState extends PosEqState {
  String? errorMessage;
  PosErrorProductState({this.errorMessage = "Error al cargar los servicios"});
}