import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'close_pos_event.dart';
part 'close_pos_state.dart';

class ClosePosBloc extends Bloc<ClosePosEvent, ClosePosState> {
  ClosePosBloc() : super(ClosePosInitial()) {
    on<ClosePosEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  void clear() {}
}
