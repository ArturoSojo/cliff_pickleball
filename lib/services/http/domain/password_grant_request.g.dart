// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_grant_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PasswordGrantRequest _$PasswordGrantRequestFromJson(
        Map<String, dynamic> json) =>
    PasswordGrantRequest(
      json['client_id'] as String,
      json['username'] as String,
      json['password'] as String,
      json['fingerprint'] as String,
    );

Map<String, dynamic> _$PasswordGrantRequestToJson(
        PasswordGrantRequest instance) =>
    <String, dynamic>{
      'client_id': instance.clientId,
      'username': instance.username,
      'password': instance.password,
      'fingerprint': instance.fingerprint,
    };
