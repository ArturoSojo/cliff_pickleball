// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tlv_comparator.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TLVObject _$TLVObjectFromJson(Map<String, dynamic> json) => TLVObject()
  ..tag = json['tag'] as String
  ..len = json['len'] as String
  ..val = json['val'] as String;

Map<String, dynamic> _$TLVObjectToJson(TLVObject instance) => <String, dynamic>{
      'tag': instance.tag,
      'len': instance.len,
      'val': instance.val,
    };
