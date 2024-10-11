import 'package:json_annotation/json_annotation.dart';
import 'package:cliff_pickleball/domain/currency_info.dart';
import 'package:cliff_pickleball/domain/merchant_affiliation.dart';
import 'package:cliff_pickleball/domain/store.dart';

part 'device.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Device {
  String? realm;
  String? businessId;
  String? id;
  String? identifier;
  String? businessName;
  String? businessEmail;
  String? businessIdDoc;
  String? sellerId;
  String? sellerName;
  String? sellerEmail;
  String? sellerIdDoc;
  String? commerceId;
  String? commerceName;
  String? commerceEmail;
  String? commerceIdDoc;
  String? channel;
  bool? configCreated;
  String? name;
  String? serial;
  String? imei;
  String? brand;
  String? model;
  String? version;
  String? communicationType;
  String? operator;
  String? url;
  String? statusReason;
  String? status;
  bool? systemCreated;
  String? currencyCode;
  CurrencyInfo? currencyInfo;
  String? bankCode;
  String? bankName;
  String? bankAcronym;
  String? bankRif;
  String? bankThumbnail;
  String? bankAcquirerCode;
  String? storeId;
  Store? store;
  bool? dukptKeyLoaded;
  bool? mkskKeyLoaded;
  List<MerchantAffiliation>? merchantAffiliations;

  Device(
      {this.realm,
      this.businessId,
      this.id,
      this.identifier,
      this.businessName,
      this.businessEmail,
      this.businessIdDoc,
      this.sellerId,
      this.sellerName,
      this.sellerEmail,
      this.sellerIdDoc,
      this.commerceId,
      this.commerceName,
      this.commerceEmail,
      this.commerceIdDoc,
      this.channel,
      this.configCreated,
      this.name,
      this.serial,
      this.imei,
      this.brand,
      this.model,
      this.version,
      this.communicationType,
      this.operator,
      this.url,
      this.statusReason,
      this.status,
      this.systemCreated,
      this.currencyCode,
      this.currencyInfo,
      this.bankCode,
      this.bankName,
      this.bankAcronym,
      this.bankRif,
      this.bankThumbnail,
      this.bankAcquirerCode,
      this.storeId,
      this.store,
      this.dukptKeyLoaded,
      this.mkskKeyLoaded,
      this.merchantAffiliations});

  factory Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);

  /// Connect the generated [_$DeviceToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$DeviceToJson(this);
}
