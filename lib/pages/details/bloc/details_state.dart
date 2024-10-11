part of 'details_bloc.dart';

@immutable
abstract class DetailsState {
  DetailsReportModel? report;
  DetailsState({this.report});
}
class DetailsInitialState extends DetailsState{
  DetailsInitialState({super.report});
}
class DetailsLoadingState extends DetailsState {
  DetailsLoadingState({super.report});
}
class DetailsSuccessState extends DetailsState {
  DetailsSuccessState({super.report});
}
class DetailsLoadedState extends DetailsState {
  DetailsLoadedState({super.report});
}
class DetailsErrorState extends DetailsState {
  String? errorMessage;
  DetailsErrorState({this.errorMessage});
}

class DetailsErrorNotListState extends DetailsState {
  String? errorMessage;
  DetailsErrorNotListState({this.errorMessage});
}