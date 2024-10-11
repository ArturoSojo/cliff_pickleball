// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_device_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MerchantDeviceResponse _$MerchantDeviceResponseFromJson(
        Map<String, dynamic> json) =>
    MerchantDeviceResponse(
      device: json['device'] == null
          ? null
          : Device.fromJson(json['device'] as Map<String, dynamic>),
      config: json['config'] == null
          ? null
          : DeviceConfig.fromJson(json['config'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MerchantDeviceResponseToJson(
        MerchantDeviceResponse instance) =>
    <String, dynamic>{
      'device': instance.device,
      'config': instance.config,
    };
