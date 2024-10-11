// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Operation _$$_OperationFromJson(Map<String, dynamic> json) => _$_Operation(
      id: json['id'] as String,
      lotNumber: json['lot_number'] as String,
      accountType: json['account_type'] as String,
      affiliationNumber: json['affiliation_number'] as String,
      amount: json['amount'] as String,
      cardHolderId: json['card_holder_id'] as String,
    );

Map<String, dynamic> _$$_OperationToJson(_$_Operation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lot_number': instance.lotNumber,
      'account_type': instance.accountType,
      'affiliation_number': instance.affiliationNumber,
      'amount': instance.amount,
      'card_holder_id': instance.cardHolderId,
    };
