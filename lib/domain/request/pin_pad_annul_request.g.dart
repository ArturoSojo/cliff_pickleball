// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pin_pad_annul_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PinPadAnnulRequest _$$_PinPadAnnulRequestFromJson(
        Map<String, dynamic> json) =>
    _$_PinPadAnnulRequest(
      emv: $enumDecode(_$EmvEnumMap, json['emv']),
      cardHolderId: json['card_holder_id'] as String,
      modePan: $enumDecode(_$ModePanEnumMap, json['mode_pan']),
      modePin: $enumDecode(_$ModePinEnumMap, json['mode_pin']),
      merchant: PinPadCardInfoRequest.fromJson(
          json['merchant'] as Map<String, dynamic>),
      accountType: json['account_type'] as String,
      deviceIdentifier: json['device_identifier'] as String,
    );

Map<String, dynamic> _$$_PinPadAnnulRequestToJson(
        _$_PinPadAnnulRequest instance) =>
    <String, dynamic>{
      'emv': _$EmvEnumMap[instance.emv]!,
      'card_holder_id': instance.cardHolderId,
      'mode_pan': _$ModePanEnumMap[instance.modePan]!,
      'mode_pin': _$ModePinEnumMap[instance.modePin]!,
      'merchant': instance.merchant.toJson(),
      'account_type': instance.accountType,
      'device_identifier': instance.deviceIdentifier,
    };

const _$EmvEnumMap = {
  Emv.SI: 'SI',
  Emv.NO: 'NO',
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
