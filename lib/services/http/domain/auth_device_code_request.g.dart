// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_device_code_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthDeviceCodeRequest _$AuthDeviceCodeRequestFromJson(
        Map<String, dynamic> json) =>
    AuthDeviceCodeRequest(
      json['fingerprint'] as String,
      json['auth_code'] as String,
      json['name'] as String?,
    );

Map<String, dynamic> _$AuthDeviceCodeRequestToJson(
        AuthDeviceCodeRequest instance) =>
    <String, dynamic>{
      'fingerprint': instance.fingerprint,
      'auth_code': instance.authCode,
      'name': instance.name,
    };
