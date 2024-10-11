// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CredentialResponse _$CredentialResponseFromJson(Map<String, dynamic> json) =>
    CredentialResponse(
      profile: json['profile'] == null
          ? null
          : Profile.fromJson(json['profile'] as Map<String, dynamic>),
      integration: json['integration'] == null
          ? null
          : Integration.fromJson(json['integration'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CredentialResponseToJson(CredentialResponse instance) =>
    <String, dynamic>{
      'profile': instance.profile,
      'integration': instance.integration,
    };
