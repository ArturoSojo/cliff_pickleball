import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'pin_pad_card_info_request.dart';

part 'pin_pad_payment_request.freezed.dart';
part 'pin_pad_payment_request.g.dart';

@freezed
class PinPadPaymentRequest with _$PinPadPaymentRequest {
  @JsonSerializable(
      explicitToJson: true,
      fieldRename: FieldRename.snake,
      includeIfNull: false)
  const factory PinPadPaymentRequest({
    required Emv emv,
    required double amount,
    String? operationDescription,
    required AccountType accountType,
    required String deviceIdentifier,
    String? externalReference,
    required String cardHolderId,
    required IdType cardHolderIdType,
    required String currency,
    required ModePan modePan,
    required ModePin modePin,
    required PaymentCardType paymentCardType,
    String? payerName,
    required PinPadCardInfoRequest merchant,
  }) = _PinPadPaymentRequest;

  factory PinPadPaymentRequest.fromJson(Map<String, Object?> json) =>
      _$PinPadPaymentRequestFromJson(json);
}

enum Emv { SI, NO }

enum AccountType { PRINCIPAL, CORRIENTE, AMEX, AHORRO, CREDITO, FAL }

enum IdType { CI, RIF, PASSPORT }

enum ModePan {
  MANUAL,
  CHIP,
  CHIP_CONTACTLESS,
  MANUAL_WITHCHIP_NOREAD,
  BAND_WITHCHIP_NOPROCESS,
  BAND
}

enum ModePin { NO_ESPECIFY, PIN, NO_PIN }

enum PaymentCardType {
  TDD,
  TDC;
}
