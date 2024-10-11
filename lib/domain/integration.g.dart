// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'integration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Integration _$IntegrationFromJson(Map<String, dynamic> json) => Integration(
      client: json['client'] == null
          ? null
          : Client.fromJson(json['client'] as Map<String, dynamic>),
      secret: json['secret'] == null
          ? null
          : Secret.fromJson(json['secret'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$IntegrationToJson(Integration instance) =>
    <String, dynamic>{
      'client': instance.client,
      'secret': instance.secret,
    };
