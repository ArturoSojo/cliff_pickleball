// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ThemeList _$$_ThemeListFromJson(Map<String, dynamic> json) => _$_ThemeList(
      list: (json['list'] as List<dynamic>)
          .map((e) => AppTheme.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$_ThemeListToJson(_$_ThemeList instance) =>
    <String, dynamic>{
      'list': instance.list,
    };
