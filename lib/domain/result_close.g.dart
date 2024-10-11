// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_close.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResultClose _$ResultCloseFromJson(Map<String, dynamic> json) => ResultClose(
      json['success'] as bool,
      json['message'] as String?,
      json['lot'] as String?,
      json['terminal'] as String?,
      json['amount_buy'] as String?,
      json['count_buy'] as String?,
      json['amount_anulate'] as String?,
      json['count_anulate'] as String?,
      json['card_type'] as String?,
      json['affiliation'] as String?,
      json['status'] as String?,
    );

Map<String, dynamic> _$ResultCloseToJson(ResultClose instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'lot': instance.lot,
      'terminal': instance.terminal,
      'amount_buy': instance.amountBuy,
      'count_buy': instance.countBuy,
      'amount_anulate': instance.amountAnulate,
      'count_anulate': instance.countAnulate,
      'card_type': instance.cardType,
      'affiliation': instance.affiliation,
      'status': instance.status,
    };
