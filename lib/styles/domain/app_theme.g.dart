// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_theme.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_AppTheme _$$_AppThemeFromJson(Map<String, dynamic> json) => _$_AppTheme(
      name: json['name'] as String,
      dflt: json['dflt'] as bool? ?? false,
      filter: Filter.fromJson(json['filter'] as Map<String, dynamic>),
      colors: AppColors.fromJson(json['colors'] as Map<String, dynamic>),
      assetsImg: AppAssets.fromJson(json['assets_img'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_AppThemeToJson(_$_AppTheme instance) =>
    <String, dynamic>{
      'name': instance.name,
      'dflt': instance.dflt,
      'filter': instance.filter.toJson(),
      'colors': instance.colors.toJson(),
      'assets_img': instance.assetsImg.toJson(),
    };
