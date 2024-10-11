import 'package:json_annotation/json_annotation.dart';
import 'package:cliff_pickleball/services/http/domain/productModel.dart';

part 'initDataModel.g.dart';

@JsonSerializable()
class Init {
  AccessToken? accessToken;
  Profile? profile;
  Profile? businessProfile;
  Country? country;
  Role? role;
  InitData? initData;
  List<Inventory>? inventory;

  Init({
    this.accessToken,
    this.profile,
    this.businessProfile,
    this.country,
    this.role,
    this.initData,
    this.inventory,
  });

  factory Init.fromJson(Map<String, dynamic> json) => _$InitFromJson(json);
  Map<String, dynamic> toJson() => _$InitToJson(this);
}

@JsonSerializable()
class AccessToken {
  String? accessToken;
  int? expiresIn;
  String? refreshToken;
  String? tokenType;

  AccessToken(
      {this.accessToken, this.expiresIn, this.refreshToken, this.tokenType});

  factory AccessToken.fromJson(Map<String, dynamic> json) =>
      _$AccessTokenFromJson(json);

  Map<String, dynamic> toJson() => _$AccessTokenToJson(this);
}

@JsonSerializable()
class Profile {
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
  List<dynamic>? bankAccounts;

  Profile(
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

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}

@JsonSerializable()
class Capital {
  String? name;
  List<dynamic>? municipalities;
  List<dynamic>? cities;

  Capital({
    this.name,
    this.municipalities,
    this.cities,
  });

  factory Capital.fromJson(Map<String, dynamic> json) =>
      _$CapitalFromJson(json);

  Map<String, dynamic> toJson() => _$CapitalToJson(this);
}

@JsonSerializable()
class States {
  String? name;
  List<dynamic>? municipalities;
  List<dynamic>? cities;

  States({
    this.name,
    this.municipalities,
    this.cities,
  });

  factory States.fromJson(Map<String, dynamic> json) => _$StatesFromJson(json);

  Map<String, dynamic> toJson() => _$StatesToJson(this);
}

@JsonSerializable()
class Country {
  String? realm;
  String? alpha2;
  String? alpha3;
  String? isoNumber;
  String? name;
  String? shortName;
  Capital? capital;
  List<States>? states;
  String? currency;
  List<dynamic>? currencies;
  Map<String, dynamic>? info;

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

  factory Country.fromJson(Map<String, dynamic> json) =>
      _$CountryFromJson(json);

  Map<String, dynamic> toJson() => _$CountryToJson(this);
}

@JsonSerializable()
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

  factory Info.fromJson(Map<String, dynamic> json) => _$InfoFromJson(json);

  Map<String, dynamic> toJson() => _$InfoToJson(this);
}

@JsonSerializable()
class Role {
  String? realm;
  String? businessId;
  String? userId;
  String? appName;
  String? appStatus;
  String? appUrl;
  String? appIcon;
  String? scopeName;
  String? scopeId;
  String? name;
  String? ownerName;
  String? ownerEmail;
  String? userName;
  String? userEmail;
  bool? thirdPartyAuthorization;
  List<View>? views;
  List<dynamic>? scopes;

  Role({
    this.businessId,
    this.userId,
    this.appName,
    this.appStatus,
    this.appUrl,
    this.appIcon,
    this.scopeName,
    this.scopeId,
    this.ownerName,
    this.ownerEmail,
    this.userName,
    this.userEmail,
    this.thirdPartyAuthorization,
    this.realm,
    this.name,
    this.views,
    this.scopes,
  });

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);
  Map<String, dynamic> toJson() => _$RoleToJson(this);
}

@JsonSerializable()
class View {
  String? name;
  String? functionality;
  String? url;
  String? type;
  String? icon;
  String? tag;
  int? sort;
  List<Action>? actions;

  View({
    this.name,
    this.functionality,
    this.url,
    this.type,
    this.icon,
    this.tag,
    this.sort,
    this.actions,
  });

  factory View.fromJson(Map<String, dynamic> json) => _$ViewFromJson(json);
  Map<String, dynamic> toJson() => _$ViewToJson(this);
}

@JsonSerializable()
class Action {
  String? name;
  int? sort;
  String? functionalityDetail;
  String? type;
  String? status;
  String? functionName;
  List<dynamic>? scopes;

  Action({
    this.name,
    this.sort,
    this.functionalityDetail,
    this.type,
    this.status,
    this.functionName,
    this.scopes,
  });

  factory Action.fromJson(Map<String, dynamic> json) => _$ActionFromJson(json);
  Map<String, dynamic> toJson() => _$ActionToJson(this);
}

@JsonSerializable()
class InitData {
  List<Inventory>? inventories;
  Ally? ally;

  InitData({
    this.inventories,
    this.ally,
  });

  factory InitData.fromJson(Map<String, dynamic> json) =>
      _$InitDataFromJson(json);
  Map<String, dynamic> toJson() => _$InitDataToJson(this);
}

@JsonSerializable()
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

  Ally({
    this.realm,
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
    this.paymentMethods,
  });

  factory Ally.fromJson(Map<String, dynamic> json) => _$AllyFromJson(json);
  Map<String, dynamic> toJson() => _$AllyToJson(this);
}

@JsonSerializable()
class Inventory {
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
  dynamic balance;
  int? minLimit;
  int? transactionFee;
  String? feeChargeType;
  List<ProductModel>? products;

  Inventory({
    this.realm,
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
    this.products,
  });

  factory Inventory.fromJson(Map<String, dynamic> json) =>
      _$InventoryFromJson(json);
  Map<String, dynamic> toJson() => _$InventoryToJson(this);
}
