import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:number_paginator/number_paginator.dart';
import '../../store/models/store_model.dart';
import '../models/details_report_model.dart';
import 'details_service.dart';


part 'details_event.dart';
part 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  Results product;
  DetailsBloc({required this.product}) : super(DetailsInitialState()) {
    on<DetailsEvent>((event, emit) {
      switch(event.runtimeType){
        case DetailsLoadingEvent:
          emit(DetailsLoadingState(report: report));
        break;
        case DetailsInitialEvent:
          emit(DetailsInitialState(report: report));
        break;
        case DetailsLoadedEvent:
          emit(DetailsLoadedState(report: report));
        break;
        case DetailsErrorEvent:
          emit(DetailsErrorState(errorMessage: errorMessage));
        break;
        case DetailsErrorNotListEvent:
          emit(DetailsErrorNotListState(errorMessage: errorMessage));
          break;
      }
    });
  }
  void init(){
    setDateGte();
    setDateLte();
  }

  TextEditingController dateInitialController = TextEditingController();
  TextEditingController dateFinalController = TextEditingController();
  NumberPaginatorController paginateController = NumberPaginatorController();

  final format2 = DateFormat('y-MM-dd');
  final format = DateFormat('y/MM/dd');
  String? errorMessage;
  DetailsReportModel? report;
  final _logger = Logger();

  Map pagingActual = {
    "first_page": {"offset": "0", "limit": "10"},
    "next_page": {"offset": "0", "limit": "10"},
    "last_page": {"offset": "0", "limit": "10"},
    "previous_page": {"offset": "0", "limit": "10"}
  };

  String offset = "0";
  String limit = "10";
  String gte = "";
  String lte = "";
  int totalPages = 1;
  int currentPage = 0;
  int totalcount = 0;
  String get timezone => DateTime.now().toLocal().timeZoneName;

  setPageChange(int p0) async {

    if (p0 == 0) {
      currentPage = 0;
      pagingActual["first_page"]["offset"] = "0";
      offset = pagingActual["first_page"]["offset"];
      add(DetailsLoadedEvent());
      await getInv();
    }
    if (p0 == (totalPages - 1)) {
      currentPage = p0;
      pagingActual["first_page"]["offset"] = pagingActual["last_page"]["offset"];
      offset = pagingActual["first_page"]["offset"];
      add(DetailsLoadedEvent());
      await getInv();
    }

    if (p0 > currentPage) {
      currentPage = p0;
      pagingActual["first_page"]["offset"] =  pagingActual["next_page"]["offset"];
      offset = pagingActual["first_page"]["offset"];
      add(DetailsLoadedEvent());
      await getInv();
    }

    if (p0 < currentPage) {
      currentPage = p0;
      pagingActual["first_page"]["offset"] =
      pagingActual["previous_page"]["offset"];
      offset = pagingActual["first_page"]["offset"];
      add(DetailsLoadedEvent());
      await getInv();
    }
  }

  setPaging(String page, data) {
    switch (page) {
      case "first":
          pagingActual["first_page"]["offset"] = data[0];
          pagingActual["first_page"]["limit"] = "10";
        break;
      case "next":
          pagingActual["next_page"]["offset"] = data[0];
          pagingActual["next_page"]["limit"] = "10";
        break;
      case "previous":
          pagingActual["previous_page"]["offset"] = data[0];
          pagingActual["previous_page"]["limit"] = "10";
        break;
      case "last":
          pagingActual["last_page"]["offset"] = data[0];
          pagingActual["last_page"]["limit"] = "10";
        break;
      default:
    }
  }

  void setCount(int count) {
    if (count != 0) {
      var c = double.parse(count.toString());
      var limit = int.parse(pagingActual["first_page"]["limit"]);
      var result = (c / limit).ceil().toInt();
      _logger.i("esta es la cantidad de paginas= $result");
      _logger.i("este es el total= $c");
      totalPages = result;
      totalcount = count;
    } else {
      totalPages = count;
      totalcount = count;
    }
    add(DetailsLoadedEvent());
  }

  void setDateGte({String? dateGte}){
    dateInitialController.text = (dateGte ?? format2.format(DateTime.now()));
    gte = "${dateGte ?? format2.format(DateTime.now().toLocal())}T00:00:00.000Z";
  }

  void setDateLte({String? dateLte}){
    dateFinalController.text = (dateLte ?? format2.format(DateTime.now()));
    lte = "${dateLte ?? format2.format(DateTime.now().toLocal())}T23:59:59.000Z";
  }

  String? validateInitialDate(date){
    if(date == null || date.isEmpty) {
      return "El periodo de inicio no puede estar vacio";
    }
    if(dateFinalController.text!=null){
      if (DateTime.parse(date).isAfter(DateTime.parse(dateFinalController.text))) {
        return "El periodo de inicio no puede ser mayor a el periodo fin";
      }
    }

    return null;
  }

  String? validateEndDate(date){
    if(date == null || date.isEmpty) {
      return "El periodo fin no puede estar vacio";
    }
    if(dateInitialController.text!=null){
      if (DateTime.parse(date).isBefore(DateTime.parse(dateInitialController.text))) {
        return "El periodo de inicio no puede ser mayor a el periodo fin";
      }
    }
    return null;
  }

  void setPagging(DetailsReportModel report){
    if (report.firstPage!=null) {
      var first = report.firstPage;
      var off = first?.split("&")[0].split("offset=").join("");
      var datas = [off];
      setPaging("first", datas);
    }
    if (report.lastPage!=null) {
      var last = report.lastPage;
      var off = last?.split("&")[0].split("offset=").join("");
      var datas = [off];
      setPaging("last", datas);
    }
    if (report.nextPage!=null) {
      var next = report.nextPage;
      var off = next?.split("&")[0].split("offset=").join("");
      var datas = [off];
      setPaging("next", datas);
    }
    if (report.previousPage!=null) {
      var previous = report.previousPage;
      var off = previous?.split("&")[0].split("offset=").join("");
      var datas = [off];
      setPaging("previous", datas);
    }
    add(DetailsLoadedEvent());
  }
  Future<void> getInv() async {

    add(DetailsLoadingEvent());

    var result = await getInventory(
        offset: offset,
        limit: limit,
        inventoryType: product.type ?? "",
        gte: gte,
        lte: lte,
        timezone: timezone
    );
    if(result.success){
      if(result.obj!=null){
        report = result.obj;
        if(report?.count!=null){
          int count = report?.count ?? 0;
          if(count>0){
            setPagging(report!);
            setCount(report?.count ?? 0);
            add(DetailsLoadedEvent());
            return;
          }else{
            errorMessage = "No hay registros para mostrar";
            add(DetailsErrorNotListEvent());
            return;
          }

        }

      }
    }
    _logger.i(result.errorMessage);
    errorMessage = result.errorMessage ?? "Error al consultar los detalles";
    add(DetailsErrorEvent());
    return;
  }

}
