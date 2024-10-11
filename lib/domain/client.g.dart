// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Client _$ClientFromJson(Map<String, dynamic> json) => Client(
      id: json['id'] as String?,
      realm: json['realm'] as String?,
      name: json['name'] as String?,
      ownerId: json['owner_id'] as String?,
      businessOwnerId: json['business_owner_id'] as String?,
      appIdentifier: json['app_identifier'] as String?,
      createdBy: json['created_by'] as String?,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$ClientToJson(Client instance) => <String, dynamic>{
      'id': instance.id,
      'realm': instance.realm,
      'name': instance.name,
      'owner_id': instance.ownerId,
      'business_owner_id': instance.businessOwnerId,
      'app_identifier': instance.appIdentifier,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt,
    };
