import 'package:basic_utils/basic_utils.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import '../../../services/http/domain/productModel.dart';

final _logger = Logger();

class InventoryModel {
  int? count;
  List<Results>? results;

  InventoryModel({this.count, this.results});

  InventoryModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['results'] != null) {
      results = [];
      json['results'].forEach((v) {
        results?.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.results != null) {
      data['results'] = this.results?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  String? realm;
  String? businessId;
  String? type;
  String? id;
  String? businessName;
  String? businessEmail;
  String? idDoc;
  String? idDocType;
  String? allyStatus;
  String? name;
  String? unit;
  double? balance;
  String? formattedBalance;
  double? minLimit;
  String? formattedMinLimit;
  double? transactionFee;
  String? formattedTransactionFee;
  String? feeChargeType;
  String? externalSapCode;
  List<Products>? products;
  Info? info;
  String? internalSapCode;

  Results(
      {this.realm,
        this.businessId,
        this.type,
        this.id,
        this.businessName,
        this.businessEmail,
        this.idDoc,
        this.idDocType,
        this.allyStatus,
        this.name,
        this.unit,
        this.balance,
        this.formattedBalance,
        this.minLimit,
        this.formattedMinLimit,
        this.transactionFee,
        this.feeChargeType,
        this.externalSapCode,
        this.products,
        this.info,
        this.internalSapCode});

  Results.fromJson(Map<String, dynamic> json) {
    NumberFormat numFormat = NumberFormat('###,###.##', 'es_VE');

    realm = json['realm'];
    businessId = json['business_id'];
    type = json['type'];
    id = json['id'];
    businessName = json['business_name'];
    businessEmail = json['business_email'];
    idDoc = json['id_doc'];
    idDocType = json['id_doc_type'];
    allyStatus = json['ally_status'];
    name = json['name'];
    unit = json['unit'];
    if(json['balance']!=null){
      if(json['balance'].runtimeType is double){
        balance = json['balance'];
        formattedBalance = numFormat.format(balance);
      }else{
        balance = double.parse(json['balance'].toString());
        formattedBalance = numFormat.format(balance);
      }
    }

    if(json['min_limit']!=null){
      if(json['min_limit'].runtimeType is double){
        minLimit = json['min_limit'];
        formattedMinLimit = numFormat.format(minLimit);
      }else{
        minLimit = double.parse(json['min_limit'].toString());
        formattedMinLimit = numFormat.format(minLimit);
      }
    }
    if(json['transaction_fee']!=null){
      if(json['transaction_fee'].runtimeType is double){
        transactionFee = json['transaction_fee'];
        formattedTransactionFee = numFormat.format(transactionFee);
      }else{
        transactionFee = double.parse(json['transaction_fee'].toString());
        formattedTransactionFee = numFormat.format(transactionFee);
      }
    }
    
    feeChargeType = json['fee_charge_type'];
    externalSapCode = json['external_sap_code'];
    // if (json['products'] != null) {
    //   products = [];
    //   json['products'].forEach((v) {
    //     products?.add(new Products.fromJson(v));
    //   });
    // }
    info = json['info'] != null ? new Info.fromJson(json['info']) : null;
    internalSapCode = json['internal_sap_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['realm'] = this.realm;
    data['business_id'] = this.businessId;
    data['type'] = this.type;
    data['id'] = this.id;
    data['business_name'] = this.businessName;
    data['business_email'] = this.businessEmail;
    data['id_doc'] = this.idDoc;
    data['id_doc_type'] = this.idDocType;
    data['ally_status'] = this.allyStatus;
    data['name'] = this.name;
    data['unit'] = this.unit;
    data['balance'] = this.balance;
    data['min_limit'] = this.minLimit;
    data['transaction_fee'] = this.transactionFee;
    data['fee_charge_type'] = this.feeChargeType;
    data['external_sap_code'] = this.externalSapCode;
    if (this.products != null) {
      data['products'] = this.products?.map((v) => v.toJson()).toList();
    }
    if (this.info != null) {
      data['info'] = this.info?.toJson();
    }
    data['internal_sap_code'] = this.internalSapCode;
    return data;
  }
}

class Products {
  bool? cancelable;
  String? id;
  String? name;
  String? url;
  String? company;
  String? area;
  String? category;
  Features? features;
  bool? isCancelable;
  List<String>? channels;
  String? status;

  Products(
      {this.cancelable,
        this.id,
        this.name,
        this.url,
        this.company,
        this.area,
        this.category,
        this.features,
        this.isCancelable,
        this.channels,
        this.status});

  Products.fromJson(Map<String, dynamic> json) {
    cancelable = json['cancelable'];
    id = json['id'];
    name = json['name'];
    url = json['url'];
    company = json['company'];
    area = json['area'];
    category = json['category'];
    features = json['features'] != null
        ? Features.fromJson(json['features'])
        : null;
    isCancelable = json['is_cancelable'];
    channels = json['channels'].cast<String>();
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cancelable'] = this.cancelable;
    data['id'] = this.id;
    data['name'] = this.name;
    data['url'] = this.url;
    data['company'] = this.company;
    data['area'] = this.area;
    data['category'] = this.category;
    if (this.features != null) {
      data['features'] = this.features?.toJson();
    }
    data['is_cancelable'] = this.isCancelable;
    data['channels'] = this.channels;
    data['status'] = this.status;
    return data;
  }
}



class Info {
  String? createdBy;
  String? createdByEmail;
  String? createdAt;
  String? updatedBy;
  String? updatedByEmail;
  String? updatedAt;

  Info(
      {this.createdBy,
        this.createdByEmail,
        this.createdAt,
        this.updatedBy,
        this.updatedByEmail,
        this.updatedAt});

  Info.fromJson(Map<String, dynamic> json) {
    createdBy = json['created_by'];
    createdByEmail = json['created_by_email'];
    createdAt = json['created_at'];
    updatedBy = json['updated_by'];
    updatedByEmail = json['updated_by_email'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_by'] = this.createdBy;
    data['created_by_email'] = this.createdByEmail;
    data['created_at'] = this.createdAt;
    data['updated_by'] = this.updatedBy;
    data['updated_by_email'] = this.updatedByEmail;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
