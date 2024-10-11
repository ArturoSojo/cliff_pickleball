// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pin_pad_payment_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PinPadPaymentRequest _$$_PinPadPaymentRequestFromJson(
        Map<String, dynamic> json) =>
    _$_PinPadPaymentRequest(
      emv: $enumDecode(_$EmvEnumMap, json['emv']),
      amount: (json['amount'] as num).toDouble(),
      operationDescription: json['operation_description'] as String?,
      accountType: $enumDecode(_$AccountTypeEnumMap, json['account_type']),
      deviceIdentifier: json['device_identifier'] as String,
      externalReference: json['external_reference'] as String?,
      cardHolderId: json['card_holder_id'] as String,
      cardHolderIdType:
          $enumDecode(_$IdTypeEnumMap, json['card_holder_id_type']),
      currency: json['currency'] as String,
      modePan: $enumDecode(_$ModePanEnumMap, json['mode_pan']),
      modePin: $enumDecode(_$ModePinEnumMap, json['mode_pin']),
      paymentCardType:
          $enumDecode(_$PaymentCardTypeEnumMap, json['payment_card_type']),
      payerName: json['payer_name'] as String?,
      merchant: PinPadCardInfoRequest.fromJson(
          json['merchant'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_PinPadPaymentRequestToJson(
    _$_PinPadPaymentRequest instance) {
  final val = <String, dynamic>{
    'emv': _$EmvEnumMap[instance.emv]!,
    'amount': instance.amount,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('operation_description', instance.operationDescription);
  val['account_type'] = _$AccountTypeEnumMap[instance.accountType]!;
  val['device_identifier'] = instance.deviceIdentifier;
  writeNotNull('external_reference', instance.externalReference);
  val['card_holder_id'] = instance.cardHolderId;
  val['card_holder_id_type'] = _$IdTypeEnumMap[instance.cardHolderIdType]!;
  val['currency'] = instance.currency;
  val['mode_pan'] = _$ModePanEnumMap[instance.modePan]!;
  val['mode_pin'] = _$ModePinEnumMap[instance.modePin]!;
  val['payment_card_type'] =
      _$PaymentCardTypeEnumMap[instance.paymentCardType]!;
  writeNotNull('payer_name', instance.payerName);
  val['merchant'] = instance.merchant.toJson();
  return val;
}

const _$EmvEnumMap = {
  Emv.SI: 'SI',
  Emv.NO: 'NO',
};

const _$AccountTypeEnumMap = {
  AccountType.PRINCIPAL: 'PRINCIPAL',
  AccountType.CORRIENTE: 'CORRIENTE',
  AccountType.AMEX: 'AMEX',
  AccountType.AHORRO: 'AHORRO',
  AccountType.CREDITO: 'CREDITO',
  AccountType.FAL: 'FAL',
};

const _$IdTypeEnumMap = {
  IdType.CI: 'CI',
  IdType.RIF: 'RIF',
  IdType.PASSPORT: 'PASSPORT',
};

const _$ModePanEnumMap = {
  ModePan.MANUAL: 'MANUAL',
  ModePan.CHIP: 'CHIP',
  ModePan.CHIP_CONTACTLESS: 'CHIP_CONTACTLESS',
  ModePan.MANUAL_WITHCHIP_NOREAD: 'MANUAL_WITHCHIP_NOREAD',
  ModePan.BAND_WITHCHIP_NOPROCESS: 'BAND_WITHCHIP_NOPROCESS',
  ModePan.BAND: 'BAND',
};

const _$ModePinEnumMap = {
  ModePin.NO_ESPECIFY: 'NO_ESPECIFY',
  ModePin.PIN: 'PIN',
  ModePin.NO_PIN: 'NO_PIN',
};

const _$PaymentCardTypeEnumMap = {
  PaymentCardType.TDD: 'TDD',
  PaymentCardType.TDC: 'TDC',
};
