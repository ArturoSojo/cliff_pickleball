// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyInfo _$CurrencyInfoFromJson(Map<String, dynamic> json) => CurrencyInfo(
      code: json['code'] as String?,
      name: json['name'] as String?,
      isoNumber: json['iso_number'] as String?,
      decimals: json['decimals'] as int?,
      symbol: json['symbol'] as String?,
      ccrOperationSymbol: json['ccr_operation_symbol'] as String?,
    );

Map<String, dynamic> _$CurrencyInfoToJson(CurrencyInfo instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'iso_number': instance.isoNumber,
      'decimals': instance.decimals,
      'symbol': instance.symbol,
      'ccr_operation_symbol': instance.ccrOperationSymbol,
    };
