import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CollectChannel {
  String? realm;
  String? businessId;
  String? id;
  String? businessName;
  String? businessEmail;
  String? businessIdDoc;
  String? name;
  String? description;
  List<CollectMethods>? collectMethods;
  bool? active;
  Info? info;

  CollectChannel({this.realm, this.businessId, this.id, this.businessName, this.businessEmail, this.businessIdDoc, this.name, this.description, this.collectMethods, this.active, this.info});

  CollectChannel.fromJson(Map<String, dynamic> json) {
    realm = json['realm'];
    businessId = json['business_id'];
    id = json['id'];
    businessName = json['business_name'];
    businessEmail = json['business_email'];
    businessIdDoc = json['business_id_doc'];
    name = json['name'];
    description = json['description'];
    if (json['collect_methods'] != null) {
      collectMethods = [];
      json['collect_methods'].forEach((v) { collectMethods?.add(new CollectMethods.fromJson(v)); });
    }
    active = json['active'];
    info = json['info'] != null ? new Info.fromJson(json['info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['realm'] = this.realm;
    data['business_id'] = this.businessId;
    data['id'] = this.id;
    data['business_name'] = this.businessName;
    data['business_email'] = this.businessEmail;
    data['business_id_doc'] = this.businessIdDoc;
    data['name'] = this.name;
    data['description'] = this.description;
    if (this.collectMethods != null) {
      data['collect_methods'] = this.collectMethods?.map((v) => v.toJson()).toList();
    }
    data['active'] = this.active;
    if (this.info != null) {
      data['info'] = this.info?.toJson();
    }
    return data;
  }
}



class CollectMethods {
  String? productName;
  String? bankAccountId;
  String? id;
  BankInfo? bankInfo;
  PaymentChannel? paymentChannel;
  String? currencyCode;
  CurrencyInfo? currencyInfo;
  String? credentialOwnerId;
  String? credentialId;
  String? credentialService;
  String? credentialDescription;
  bool? allowed;
  String? state;
  String? phone;
  String? formattedPhone;
  String? idDoc;

  CollectMethods({this.productName, this.bankAccountId, this.id, this.bankInfo, this.paymentChannel, this.currencyCode, this.currencyInfo, this.credentialOwnerId, this.credentialId, this.credentialService, this.credentialDescription, this.allowed, this.state, this.phone, this.idDoc});

  CollectMethods.fromJson(Map<String, dynamic> json) {

    var maskFormatter = MaskTextInputFormatter(
        mask: '(###) ###-####',
        filter: { "#": RegExp(r'[0-9]') },
        type: MaskAutoCompletionType.lazy
    );
    productName = json['product_name'];
    bankAccountId = json['bank_account_id'];
    id = json['id'];
    bankInfo = json['bank_info'] != null ? new BankInfo.fromJson(json['bank_info']) : null;
    paymentChannel = json['payment_channel'] != null ? new PaymentChannel.fromJson(json['payment_channel']) : null;
    currencyCode = json['currency_code'];
    currencyInfo = json['currency_info'] != null ? new CurrencyInfo.fromJson(json['currency_info']) : null;
    credentialOwnerId = json['credential_owner_id'];
    credentialId = json['credential_id'];
    credentialService = json['credential_service'];
    credentialDescription = json['credential_description'];
    allowed = json['allowed'];
    state = json['state'];
    phone = json['phone'];
    if(phone!=null){
      formattedPhone = maskFormatter.maskText(phone!);
    }
    idDoc = json['id_doc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_name'] = this.productName;
    data['bank_account_id'] = this.bankAccountId;
    data['id'] = this.id;
    if (this.bankInfo != null) {
      data['bank_info'] = this.bankInfo?.toJson();
    }
    if (this.paymentChannel != null) {
      data['payment_channel'] = this.paymentChannel?.toJson();
    }
    data['currency_code'] = this.currencyCode;
    if (this.currencyInfo != null) {
      data['currency_info'] = this.currencyInfo?.toJson();
    }
    data['credential_owner_id'] = this.credentialOwnerId;
    data['credential_id'] = this.credentialId;
    data['credential_service'] = this.credentialService;
    data['credential_description'] = this.credentialDescription;
    data['allowed'] = this.allowed;
    data['state'] = this.state;
    data['phone'] = this.phone;
    data['id_doc'] = this.idDoc;
    return data;
  }
}

class BankInfo {
  String? code;
  String? name;
  String? acronym;
  String? thumbnail;


  BankInfo({this.code, this.name, this.acronym, this.thumbnail});

  BankInfo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    acronym = json['acronym'];
    thumbnail = json['thumbnail'];
;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    data['acronym'] = this.acronym;
    data['thumbnail'] = this.thumbnail;
    return data;
  }
}


class PaymentChannel {
  String? productName;
  String? type;
  String? action;

  PaymentChannel({this.productName, this.type, this.action});

  PaymentChannel.fromJson(Map<String, dynamic> json) {
    productName = json['product_name'];
    type = json['type'];
    action = json['action'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_name'] = this.productName;
    data['type'] = this.type;
    data['action'] = this.action;
    return data;
  }
}

class CurrencyInfo {
  String? code;
  String? name;
  String? isoNumber;
  int? decimals;
  String? symbol;
  String? ccrOperationSymbol;

  CurrencyInfo({this.code, this.name, this.isoNumber, this.decimals, this.symbol, this.ccrOperationSymbol});

  CurrencyInfo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    isoNumber = json['iso_number'];
    decimals = json['decimals'];
    symbol = json['symbol'];
    ccrOperationSymbol = json['ccr_operation_symbol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    data['iso_number'] = this.isoNumber;
    data['decimals'] = this.decimals;
    data['symbol'] = this.symbol;
    data['ccr_operation_symbol'] = this.ccrOperationSymbol;
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

  Info({this.createdBy, this.createdByEmail, this.createdAt, this.updatedBy, this.updatedByEmail, this.updatedAt});

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
