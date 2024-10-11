// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_affiliation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MerchantAffiliation _$MerchantAffiliationFromJson(Map<String, dynamic> json) =>
    MerchantAffiliation(
      affiliationPetitionId: json['affiliation_petition_id'] as String?,
      affiliationNumber: json['affiliation_number'] as String?,
      bankCode: json['bank_code'] as String?,
      bankName: json['bank_name'] as String?,
      bankAcronym: json['bank_acronym'] as String?,
      bankRif: json['bank_rif'] as String?,
      bankAcquirerCode: json['bank_acquirer_code'] as String?,
      bankThumbnail: json['bank_thumbnail'] as String?,
      bankTransactionalPaymentChannel:
          (json['bank_transactional_payment_channel'] as Map<String, dynamic>?)
              ?.map(
        (k, e) => MapEntry($enumDecode(_$PaymentCardTypeEnumMap, k),
            $enumDecodeNullable(_$TransactionalChannelEnumMap, e)),
      ),
      currencyCode: json['currency_code'] as String?,
      currencyInfo: json['currency_info'] == null
          ? null
          : CurrencyInfo.fromJson(
              json['currency_info'] as Map<String, dynamic>),
      terminals: (json['terminals'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry($enumDecode(_$TransactionTypeEnumMap, k), e as String?),
      ),
      terminalSet: (json['terminal_set'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toSet(),
    );

Map<String, dynamic> _$MerchantAffiliationToJson(
        MerchantAffiliation instance) =>
    <String, dynamic>{
      'affiliation_petition_id': instance.affiliationPetitionId,
      'affiliation_number': instance.affiliationNumber,
      'bank_code': instance.bankCode,
      'bank_name': instance.bankName,
      'bank_acronym': instance.bankAcronym,
      'bank_rif': instance.bankRif,
      'bank_acquirer_code': instance.bankAcquirerCode,
      'bank_thumbnail': instance.bankThumbnail,
      'bank_transactional_payment_channel':
          instance.bankTransactionalPaymentChannel?.map((k, e) => MapEntry(
              _$PaymentCardTypeEnumMap[k]!, _$TransactionalChannelEnumMap[e])),
      'currency_code': instance.currencyCode,
      'currency_info': instance.currencyInfo,
      'terminals': instance.terminals
          ?.map((k, e) => MapEntry(_$TransactionTypeEnumMap[k]!, e)),
      'terminal_set': instance.terminalSet?.toList(),
    };

const _$TransactionalChannelEnumMap = {
  TransactionalChannel.CHANNEL_7_3: 'CHANNEL_7_3',
  TransactionalChannel.CHANNEL_7_7: 'CHANNEL_7_7',
};

const _$PaymentCardTypeEnumMap = {
  PaymentCardType.TDD: 'TDD',
  PaymentCardType.TDC: 'TDC',
};

const _$TransactionTypeEnumMap = {
  TransactionType.CREDIT: 'CREDIT',
  TransactionType.DEBIT: 'DEBIT',
  TransactionType.AMEX: 'AMEX',
  TransactionType.EXTRA_FINANCING: 'EXTRA_FINANCING',
};
