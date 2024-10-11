import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:optional/optional.dart';
import 'package:cliff_pickleball/pages/store/bloc/store_service.dart';
import '../models/store_model.dart';

part 'store_event.dart';
part 'store_state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  StoreBloc() : super(StoreLoadingState()) {
    on<StoreEvent>((event, emit) async {
      switch (event.runtimeType) {
        case StoreLoadingEvent:
          emit(StoreLoadingState(inventory: inventory));
          break;
        case StoreInitialEvent:
          emit(StoreInitialState(inventory: inventory));
          break;
        case StoreLoadedEvent:
          emit(StoreLoadedState(
              inventory: inventory,
              consigned: consigned,
              listTypes: listTypes));
          break;
        case StoreErrorEvent:
          emit(StoreErrorState(errorMessage: errorMessage));
          break;
        case StoreGoNextEvent:
          emit(StoreGoNextState(
              next: next, product: mproduct, listTypes: listTypes));
          break;
      }
    });
  }
  String next = "";
  String errorMessage = "";
  InventoryModel? inventory;
  final Logger _logger = Logger();
  List<String> listTypes = [];
  Results? consigned;
  Results? mproduct;

  void goNext(
      {required String path, Results? product, List<String>? listTypes}) {
    next = path;
    mproduct = product;
    listTypes = listTypes;
    add(const StoreGoNextEvent());
  }

  Future<void> mInventory() async {
    var result = await getInventory();
    if (result.success) {
      if (result.obj != null) {
        inventory = result.obj;
        if (inventory?.count != 0) {
          for (int i = 0; i < inventory!.results!.length; i++) {
            if (inventory!.results![i].type != null) {
              listTypes.add(inventory!.results![i].type!);
            }
          }
          var consignedResult = inventory?.results
              ?.where((x) => x.name == "POSPAGO" && (x.minLimit ?? 0) > 0)
              .firstOptional
              .orElseNull;
          if (consignedResult != null) {
            consigned = consignedResult;
          }
          add(const StoreLoadedEvent());
        } else {
          listTypes = [];
          _logger.i(result.errorMessage);
          errorMessage = result.errorMessage ??
              "El aliado no posee actualmente un inventario asignado";
          add(const StoreErrorEvent());
        }
      }
    } else {
      listTypes = [];
      _logger.i(result.errorMessage);
      errorMessage = result.errorMessage ?? "Error al obtener el inventario";
      add(const StoreErrorEvent());
    }
  }
}
