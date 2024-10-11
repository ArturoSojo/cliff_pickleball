// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Device _$DeviceFromJson(Map<String, dynamic> json) => Device(
      realm: json['realm'] as String?,
      businessId: json['business_id'] as String?,
      id: json['id'] as String?,
      identifier: json['identifier'] as String?,
      businessName: json['business_name'] as String?,
      businessEmail: json['business_email'] as String?,
      businessIdDoc: json['business_id_doc'] as String?,
      sellerId: json['seller_id'] as String?,
      sellerName: json['seller_name'] as String?,
      sellerEmail: json['seller_email'] as String?,
      sellerIdDoc: json['seller_id_doc'] as String?,
      commerceId: json['commerce_id'] as String?,
      commerceName: json['commerce_name'] as String?,
      commerceEmail: json['commerce_email'] as String?,
      commerceIdDoc: json['commerce_id_doc'] as String?,
      channel: json['channel'] as String?,
      configCreated: json['config_created'] as bool?,
      name: json['name'] as String?,
      serial: json['serial'] as String?,
      imei: json['imei'] as String?,
      brand: json['brand'] as String?,
      model: json['model'] as String?,
      version: json['version'] as String?,
      communicationType: json['communication_type'] as String?,
      operator: json['operator'] as String?,
      url: json['url'] as String?,
      statusReason: json['status_reason'] as String?,
      status: json['status'] as String?,
      systemCreated: json['system_created'] as bool?,
      currencyCode: json['currency_code'] as String?,
      currencyInfo: json['currency_info'] == null
          ? null
          : CurrencyInfo.fromJson(
              json['currency_info'] as Map<String, dynamic>),
      bankCode: json['bank_code'] as String?,
      bankName: json['bank_name'] as String?,
      bankAcronym: json['bank_acronym'] as String?,
      bankRif: json['bank_rif'] as String?,
      bankThumbnail: json['bank_thumbnail'] as String?,
      bankAcquirerCode: json['bank_acquirer_code'] as String?,
      storeId: json['store_id'] as String?,
      store: json['store'] == null
          ? null
          : Store.fromJson(json['store'] as Map<String, dynamic>),
      dukptKeyLoaded: json['dukpt_key_loaded'] as bool?,
      mkskKeyLoaded: json['mksk_key_loaded'] as bool?,
      merchantAffiliations: (json['merchant_affiliations'] as List<dynamic>?)
          ?.map((e) => MerchantAffiliation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DeviceToJson(Device instance) => <String, dynamic>{
      'realm': instance.realm,
      'business_id': instance.businessId,
      'id': instance.id,
      'identifier': instance.identifier,
      'business_name': instance.businessName,
      'business_email': instance.businessEmail,
      'business_id_doc': instance.businessIdDoc,
      'seller_id': instance.sellerId,
      'seller_name': instance.sellerName,
      'seller_email': instance.sellerEmail,
      'seller_id_doc': instance.sellerIdDoc,
      'commerce_id': instance.commerceId,
      'commerce_name': instance.commerceName,
      'commerce_email': instance.commerceEmail,
      'commerce_id_doc': instance.commerceIdDoc,
      'channel': instance.channel,
      'config_created': instance.configCreated,
      'name': instance.name,
      'serial': instance.serial,
      'imei': instance.imei,
      'brand': instance.brand,
      'model': instance.model,
      'version': instance.version,
      'communication_type': instance.communicationType,
      'operator': instance.operator,
      'url': instance.url,
      'status_reason': instance.statusReason,
      'status': instance.status,
      'system_created': instance.systemCreated,
      'currency_code': instance.currencyCode,
      'currency_info': instance.currencyInfo,
      'bank_code': instance.bankCode,
      'bank_name': instance.bankName,
      'bank_acronym': instance.bankAcronym,
      'bank_rif': instance.bankRif,
      'bank_thumbnail': instance.bankThumbnail,
      'bank_acquirer_code': instance.bankAcquirerCode,
      'store_id': instance.storeId,
      'store': instance.store,
      'dukpt_key_loaded': instance.dukptKeyLoaded,
      'mksk_key_loaded': instance.mkskKeyLoaded,
      'merchant_affiliations': instance.merchantAffiliations,
    };
