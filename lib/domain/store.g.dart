// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Store _$StoreFromJson(Map<String, dynamic> json) => Store(
      id: json['id'] as String?,
      name: json['name'] as String?,
      address: json['address'] as String?,
      phones: (json['phones'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      emails:
          (json['emails'] as List<dynamic>?)?.map((e) => e as String).toList(),
      statusReason: json['status_reason'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$StoreToJson(Store instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'phones': instance.phones,
      'emails': instance.emails,
      'status_reason': instance.statusReason,
      'status': instance.status,
    };
