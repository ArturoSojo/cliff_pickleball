import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/initDataModel.dart';
import '../../../services/cacheService.dart';
import '../../../services/http/domain/productModel.dart';
import 'package:logger/logger.dart';

part 'sales_eq_event.dart';
part 'sales_eq_state.dart';

class SalesEqBloc extends Bloc<SalesEqEvent, SalesEqState> {
  final _cache = Cache();
  final _logger = Logger();
  List<ProductModel> products = [];
  Profile? profile = null;

  SalesEqBloc() : super(SalesInitialState()) {
    on<SalesEqEvent>((event, emitter) async{
      switch (event.runtimeType) {
        case SalesInitialEvent:
          if(products!=null && profile!=null){
            emitter(SalesLoadedProductState(products: products, profile: profile));
          }else{
            emitter(SalesLoadingProductState());
            getProducts();
          }
        break;
        case SalesErrorProductEvent:
          emitter(SalesErrorProductState());
          break;
        case SalesLoadedProductEvent:
          emitter(SalesLoadedProductState(products: products, profile: profile));
        break;

      }
    });
  }
  void init(){
    products = [];
    add(SalesInitialEvent());
  }
  Future<void> getProducts() async {
    add(SalesLoadingProductEvent());
    Init? init = await _cache.getInitData("servicepay");
    List<Inventory>? inventories = init?.initData?.inventories;
    Profile? model = await init?.profile;

    if(model!=null){
      profile = model;
    }

    if(inventories?.length!=0){
      products = [];
      inventories?.forEach((inv) {
        if(inv.products?.length!=0){
          products.addAll(inv.products!);
          add(SalesLoadedProductEvent());
        }
      });

    }
  }
}
