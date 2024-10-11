import 'package:injectable/injectable.dart';
import '../../../services/http/domain/productModel.dart';
import '../../../services/http/domain/role_request.dart';

class Init {
  AccessToken? accessToken;
  ProfileModel? profile;
  ProfileModel? businessProfile;
  Country? country;
  Role? role;
  InitData? initData;
  List<Inventories>? inventories;

  Init(
      {this.accessToken,
        this.profile,
        this.businessProfile,
        this.country,
        this.role,
        this.initData,
        this.inventories});

  Init.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'] != null
        ? AccessToken.fromJson(json['access_token'])
        : null;
    profile =
    json['profile'] != null ? ProfileModel.fromJson(json['profile']) : null;
    businessProfile = json['business_profile'] != null
        ? ProfileModel.fromJson(json['business_profile'])
        : null;
    country =
    json['country'] != null ? Country.fromJson(json['country']) : null;
    role = json['role'] != null ? Role.fromJson(json['role']) : null;
    initData = json['init_data'] != null
        ? InitData.fromJson(json['init_data'])
        : null;
    if (json['inventories'] != null) {
      inventories = <Inventories>[];
      json['inventories'].forEach((v) {
        inventories?.add(Inventories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.accessToken != null) {
      data['access_token'] = this.accessToken?.toJson();
    }
    if (this.profile != null) {
      data['profile'] = this.profile?.toJson();
    }
    if (this.businessProfile != null) {
      data['business_profile'] = this.businessProfile?.toJson();
    }
    if (this.country != null) {
      data['country'] = this.country?.toJson();
    }
    if (this.role != null) {
      data['role'] = this.role?.toJson();
    }
    if (this.initData != null) {
      data['init_data'] = this.initData?.toJson();
    }
    if (this.inventories != null) {
      data['inventories'] = this.inventories?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AccessToken {
  String? accessToken;
  int? expiresIn;
  String? refreshToken;
  String? tokenType;

  AccessToken(
      {this.accessToken, this.expiresIn, this.refreshToken, this.tokenType});

  AccessToken.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    expiresIn = json['expires_in'];
    refreshToken = json['refresh_token'];
    tokenType = json['token_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['expires_in'] = this.expiresIn;
    data['refresh_token'] = this.refreshToken;
    data['token_type'] = this.tokenType;
    return data;
  }
}

class ProfileModel {
  String? realm;
  String? id;
  String? emailDeflt;
  String? firstName;
  String? lastName;
  String? businessName;
  String? alias;
  String? country;
  bool? lock;
  String? idDoc;
  String? idDocType;
  String? type;
  String? phoneDeflt;
  List<String>? bankAccounts;

  ProfileModel(
      {this.realm,
        this.id,
        this.emailDeflt,
        this.firstName,
        this.lastName,
        this.businessName,
        this.alias,
        this.country,
        this.lock,
        this.idDoc,
        this.idDocType,
        this.type,
        this.phoneDeflt,
        this.bankAccounts});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    realm = json['realm'];
    id = json['id'];
    emailDeflt = json['email_deflt'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    businessName = json['business_name'];
    alias = json['alias'];
    country = json['country'];
    lock = json['lock'];
    idDoc = json['id_doc'];
    idDocType = json['id_doc_type'];
    type = json['type'];
    phoneDeflt = json['phone_deflt'];
    if (json['bank_accounts'] != null) {
      bankAccounts = [];
      json['bank_accounts'].forEach((v) {
        bankAccounts?.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['realm'] = this.realm;
    data['id'] = this.id;
    data['email_deflt'] = this.emailDeflt;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['business_name'] = this.businessName;
    data['alias'] = this.alias;
    data['country'] = this.country;
    data['lock'] = this.lock;
    data['id_doc'] = this.idDoc;
    data['id_doc_type'] = this.idDocType;
    data['type'] = this.type;
    data['phone_deflt'] = this.phoneDeflt;
    if (this.bankAccounts != null) {
      data['bank_accounts'] = this.bankAccounts?.map((v) => v).toList();
    }
    return data;
  }
}

class Country {
  String? realm;
  String? alpha2;
  String? alpha3;
  String? isoNumber;
  String? name;
  String? shortName;
  Capital? capital;
  List<String>? states;
  String? currency;
  List<String>? currencies;
  Info? info;

  Country(
      {this.realm,
        this.alpha2,
        this.alpha3,
        this.isoNumber,
        this.name,
        this.shortName,
        this.capital,
        this.states,
        this.currency,
        this.currencies,
        this.info});

  Country.fromJson(Map<String, dynamic> json) {
    realm = json['realm'];
    alpha2 = json['alpha2'];
    alpha3 = json['alpha3'];
    isoNumber = json['iso_number'];
    name = json['name'];
    shortName = json['short_name'];
    capital =
    json['capital'] != null ? Capital.fromJson(json['capital']) : null;
    if (json['states'] != null) {
      states = [];
      for (var state in json['states']) {
        states?.add(state);
      }
    }
    currency = json['currency'];
    currencies = json['currencies'].cast<String>();
    info = json['info'] != null ? Info.fromJson(json['info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['realm'] = this.realm;
    data['alpha2'] = this.alpha2;
    data['alpha3'] = this.alpha3;
    data['iso_number'] = this.isoNumber;
    data['name'] = this.name;
    data['short_name'] = this.shortName;
    if (this.capital != null) {
      data['capital'] = this.capital?.toJson();
    }
    if (this.states != null) {
      data['states'] = this.states?.map((v) => v).toList();
    }
    data['currency'] = this.currency;
    data['currencies'] = this.currencies;
    if (this.info != null) {
      data['info'] = this.info?.toJson();
    }
    return data;
  }
}

class Capital {
  String? name;
  List<String>? municipalities;
  List<String>? cities;

  Capital({this.name, this.municipalities, this.cities});

  Capital.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['municipalities'] != null) {
      municipalities = [];
      json['municipalities'].forEach((v) {
        municipalities?.add(v);
      });
    }
    if (json['cities'] != null) {
      cities = [];
      json['cities'].forEach((v) {
        cities?.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    if (this.municipalities != null) {
      data['municipalities'] =
          this.municipalities?.map((v) => v).toList();
    }
    if (this.cities != null) {
      data['cities'] = this.cities?.map((v) => v).toList();
    }
    return data;
  }
}

class Info {
  String? createdBy;
  String? createdByEmail;
  String? createdAt;

  Info({this.createdBy, this.createdByEmail, this.createdAt});

  Info.fromJson(Map<String, dynamic> json) {
    createdBy = json['created_by'];
    createdByEmail = json['created_by_email'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['created_by'] = this.createdBy;
    data['created_by_email'] = this.createdByEmail;
    data['created_at'] = this.createdAt;
    return data;
  }
}







class InitData {
  List<Inventories>? inventories;
  Ally? ally;

  InitData({this.inventories, this.ally});

  InitData.fromJson(Map<String, dynamic> json) {
    if (json['inventories'] != null) {
      inventories = <Inventories>[];
      json['inventories']?.forEach((v) {
        inventories?.add(Inventories.fromJson(v));
      });
    }
    ally = json['ally'] != null ? Ally.fromJson(json['ally']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.inventories != null) {
      data['inventories'] = this.inventories?.map((v) => v.toJson()).toList();
    }
    if (this.ally != null) {
      data['ally'] = this.ally?.toJson();
    }
    return data;
  }
}


class Inventories {
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
  String? balance;
  String? minLimit;
  String? transactionFee;
  String? feeChargeType;
  String? externalSapCode;
  List<ProductModel>? products;
  String? internalSapCode;

  Inventories(
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
        this.minLimit,
        this.transactionFee,
        this.feeChargeType,
        this.externalSapCode,
        this.products,
        this.internalSapCode});

  Inventories.fromJson(Map<String, dynamic> json) {
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
    balance = json['balance'].toString();
    minLimit = json['min_limit'].toString();
    transactionFee = json['transaction_fee'].toString();
    feeChargeType = json['fee_charge_type'];
    externalSapCode = json['external_sap_code'];
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products?.add(ProductModel.fromJson(v));
      });
    }
    internalSapCode = json['internal_sap_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
    data['internal_sap_code'] = this.internalSapCode;
    return data;
  }
}




class Ally {
  String? realm;
  String? businessId;
  String? id;
  String? businessName;
  String? businessEmail;
  String? businessIdDoc;
  String? businessIdDocType;
  String? allyName;
  String? allyEmail;
  String? allyIdDoc;
  String? allyIdDocType;
  String? status;
  List<String>? paymentMethods;

  Ally(
      {this.realm,
        this.businessId,
        this.id,
        this.businessName,
        this.businessEmail,
        this.businessIdDoc,
        this.businessIdDocType,
        this.allyName,
        this.allyEmail,
        this.allyIdDoc,
        this.allyIdDocType,
        this.status,
        this.paymentMethods});

  Ally.fromJson(Map<String, dynamic> json) {
    realm = json['realm'];
    businessId = json['business_id'];
    id = json['id'];
    businessName = json['business_name'];
    businessEmail = json['business_email'];
    businessIdDoc = json['business_id_doc'];
    businessIdDocType = json['business_id_doc_type'];
    allyName = json['ally_name'];
    allyEmail = json['ally_email'];
    allyIdDoc = json['ally_id_doc'];
    allyIdDocType = json['ally_id_doc_type'];
    status = json['status'];
    paymentMethods = json['payment_methods'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['realm'] = this.realm;
    data['business_id'] = this.businessId;
    data['id'] = this.id;
    data['business_name'] = this.businessName;
    data['business_email'] = this.businessEmail;
    data['business_id_doc'] = this.businessIdDoc;
    data['business_id_doc_type'] = this.businessIdDocType;
    data['ally_name'] = this.allyName;
    data['ally_email'] = this.allyEmail;
    data['ally_id_doc'] = this.allyIdDoc;
    data['ally_id_doc_type'] = this.allyIdDocType;
    data['status'] = this.status;
    data['payment_methods'] = this.paymentMethods;
    return data;
  }
}
