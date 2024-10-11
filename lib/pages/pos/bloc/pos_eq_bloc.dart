import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/initDataModel.dart';
import '../../../services/cacheService.dart';
import '../../../services/http/domain/productModel.dart';
import 'package:logger/logger.dart';

part 'pos_eq_event.dart';
part 'pos_eq_state.dart';

class PosEqBloc extends Bloc<PosEqEvent, PosEqState> {
  final _cache = Cache();
  final _logger = Logger();
  List<View> views = [];
  Profile? profile;

  PosEqBloc() : super(PosInitialState()) {
    on<PosEqEvent>((event, emitter) async{
      switch (event.runtimeType) {
        case PosInitialEvent:
          if(views!=null && profile!=null){
            emitter(PosLoadedProductState(views: views, profile: profile));
          }else{
            emitter(PosLoadingProductState());
            getViews();
          }
        break;
        case PosErrorProductEvent:
          emitter(PosErrorProductState());
          break;
        case PosLoadedProductEvent:
          emitter(PosLoadedProductState(views: views, profile: profile));
        break;

      }
    });
  }
  void init(){
    views = [];
    add(PosInitialEvent());
  }
  Future<void> getViews() async {
    add(PosLoadingProductEvent());
    Init? init = await _cache.getInitData("pinpagos");
    List<View>? newViews = init?.role?.views;
    Profile? model = await init?.profile;

    if(model!=null){
      profile = model;
    }
    if(newViews!=null){
      views = newViews;
    }
    add(PosLoadedProductEvent());
  }
}
