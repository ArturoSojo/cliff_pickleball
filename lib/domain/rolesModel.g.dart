// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rolesModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RolesModel _$RolesModelFromJson(Map<String, dynamic> json) => RolesModel(
      json['pinpagos'] as bool,
      json['servicepay'] as bool,
    );

Map<String, dynamic> _$RolesModelToJson(RolesModel instance) =>
    <String, dynamic>{
      'servicepay': instance.servicepay,
      'pinpagos': instance.pinpagos,
    };
