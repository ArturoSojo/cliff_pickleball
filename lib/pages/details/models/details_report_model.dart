import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../../utils/translate.dart';
import '../../../utils/utils.dart';

final _logger = Logger();

class DetailsReportModel {
  String? firstPage;
  String? nextPage;
  String? lastPage;
  String? previousPage;
  int? count;
  List<Movement>? results;

  DetailsReportModel(
      {this.firstPage, this.nextPage, this.lastPage, this.previousPage, this.count, this.results});

  DetailsReportModel.fromJson(Map<String, dynamic> json) {
    firstPage = json['first_page'];
    nextPage = json['next_page'];
    lastPage = json['last_page'];
    previousPage = json['previous_page'];
    count = json['count'];
    if (json['results'] != null) {
      results = <Movement>[];
      json['results'].forEach((v) {
        results?.add(new Movement.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_page'] = this.firstPage;
    data['next_page'] = this.nextPage;
    data['last_page'] = this.lastPage;
    data['previous_page'] = this.previousPage;
    data['count'] = this.count;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Movement {
  String? realm;
  String? businessId;
  String? inventoryType;
  String? inventoryId;
  int? intDate;
  String? id;
  String? businessName;
  String? businessEmail;
  String? idDoc;
  String? idDocType;
  String? type;
  String? formattedType;
  String? service;
  String? formattedService;
  String? description;
  String? formattedDescription;
  double? amount;
  String? formattedAmount;
  String? inventoryName;
  String? inventoryUnit;
  double? inventoryBalance;
  String? formattedInventoryBalance;
  double? inventoryBalanceAfter;
  String? formattedInventoryBalanceAfter;
  String? userId;
  String? userEmail;
  String? ip;
  String? timestamp;
  String? formattedTimestamp;

  Movement(
      {this.realm,
        this.businessId,
        this.inventoryType,
        this.inventoryId,
        this.intDate,
        this.id,
        this.businessName,
        this.businessEmail,
        this.idDoc,
        this.idDocType,
        this.type,
        this.formattedType,
        this.service,
        this.formattedService,
        this.description,
        this.formattedDescription,
        this.amount,
        this.formattedAmount,
        this.inventoryName,
        this.inventoryUnit,
        this.inventoryBalance,
        this.formattedInventoryBalance,
        this.inventoryBalanceAfter,
        this.formattedInventoryBalanceAfter,
        this.userId,
        this.userEmail,
        this.ip,
        this.timestamp,
        this.formattedTimestamp});

  Movement.fromJson(Map<String, dynamic> json) {
    var numFormat = CurrencyTextInputFormatter(
        locale: 'es_VE',
        decimalDigits: 2,
        symbol: ""
    );
    final format = DateFormat(
      'y-MM-dd hh:mm:ss a',
    );

    realm = json['realm'];
    businessId = json['business_id'];
    inventoryType = json['inventory_type'];
    inventoryId = json['inventory_id'];
    intDate = json['int_date'];
    id = json['id'];
    businessName = json['business_name'];
    businessEmail = json['business_email'];
    idDoc = json['id_doc'];
    idDocType = json['id_doc_type'];
    type = json['type'];
    if(type!=null){
      formattedType = translate(type ?? "");
    }
    service = json['service'];
    if(service!=null){
      formattedService = translate(service ?? "");
    }
    description = json['description'];
    if(description!=null){
      formattedDescription = translate(description ?? "");
    }
    if(json["amount"]!=null){
      switch(json["amount"].runtimeType){
        case int:
          amount = double.parse(json["amount"].toStringAsFixed(2));
          formattedAmount = numFormat.format(amount!.toStringAsFixed(2));
        break;
        case double:
          amount = json['amount'];
          formattedAmount = numFormat.format(amount!.toStringAsFixed(2));
        break;
      }
    }


    inventoryName = json['inventory_name'];
    inventoryUnit = json['inventory_unit'];
    inventoryBalance = MyUtils.parseAmount(json['inventory_balance']);
    if(inventoryBalance!=null){
      formattedInventoryBalance = numFormat.format(inventoryBalance!.toStringAsFixed(2));
    }
    inventoryBalanceAfter = MyUtils.parseAmount(json['inventory_balance_after']);
    if(inventoryBalanceAfter!=null){
      formattedInventoryBalanceAfter = numFormat.format(inventoryBalanceAfter!.toStringAsFixed(2));
    }
    userId = json['user_id'];
    userEmail = json['user_email'];
    ip = json['ip'];
    timestamp = json['timestamp'];
    if(timestamp!=null){
      formattedTimestamp = format.format(DateTime.parse(timestamp!).toLocal());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['realm'] = this.realm;
    data['business_id'] = this.businessId;
    data['inventory_type'] = this.inventoryType;
    data['inventory_id'] = this.inventoryId;
    data['int_date'] = this.intDate;
    data['id'] = this.id;
    data['business_name'] = this.businessName;
    data['business_email'] = this.businessEmail;
    data['id_doc'] = this.idDoc;
    data['id_doc_type'] = this.idDocType;
    data['type'] = this.type;
    data['service'] = this.service;
    data['description'] = this.description;
    data['amount'] = this.amount;
    data['inventory_name'] = this.inventoryName;
    data['inventory_unit'] = this.inventoryUnit;
    data['inventory_balance'] = this.inventoryBalance;
    data['inventory_balance_after'] = this.inventoryBalanceAfter;
    data['user_id'] = this.userId;
    data['user_email'] = this.userEmail;
    data['ip'] = this.ip;
    data['timestamp'] = this.timestamp;
    return data;
  }
}
