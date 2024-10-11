// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
      realm: json['realm'] as String?,
      id: json['id'] as String?,
      emailDeflt: json['email_deflt'] as String?,
      businessName: json['business_name'] as String?,
      alias: json['alias'] as String?,
      country: json['country'] as String?,
      lock: json['lock'] as bool?,
      idDoc: json['id_doc'] as String?,
      idDocType: json['id_doc_type'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'realm': instance.realm,
      'id': instance.id,
      'email_deflt': instance.emailDeflt,
      'business_name': instance.businessName,
      'alias': instance.alias,
      'country': instance.country,
      'lock': instance.lock,
      'id_doc': instance.idDoc,
      'id_doc_type': instance.idDocType,
      'type': instance.type,
    };
