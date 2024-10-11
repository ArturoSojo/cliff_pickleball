// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secret.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Secret _$SecretFromJson(Map<String, dynamic> json) => Secret(
      clientId: json['client_id'] as String?,
      id: json['id'] as String?,
      createdBy: json['created_by'] as String?,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$SecretToJson(Secret instance) => <String, dynamic>{
      'client_id': instance.clientId,
      'id': instance.id,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt,
    };
