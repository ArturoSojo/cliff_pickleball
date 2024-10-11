// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_token_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessTokenResponse _$AccessTokenResponseFromJson(Map<String, dynamic> json) =>
    AccessTokenResponse(
      accessToken: json['access_token'] as String?,
      expiresIn: json['expires_in'] as int?,
      tokenType: json['token_type'] as String?,
      refreshToken: json['refresh_token'] as String?,
      expireDate: json['expire_date'] == null
          ? null
          : DateTime.parse(json['expire_date'] as String),
    );

Map<String, dynamic> _$AccessTokenResponseToJson(
        AccessTokenResponse instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'expires_in': instance.expiresIn,
      'token_type': instance.tokenType,
      'refresh_token': instance.refreshToken,
      'expire_date': instance.expireDate?.toIso8601String(),
    };
