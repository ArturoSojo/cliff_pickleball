import 'package:json_annotation/json_annotation.dart';
import 'package:cliff_pickleball/domain/currency_info.dart';
import 'package:cliff_pickleball/domain/terminals.dart';

import 'bank_transactional_payment_channel.dart';

part 'merchant_affiliation.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MerchantAffiliation {
  String? affiliationPetitionId;
  String? affiliationNumber;
  String? bankCode;
  String? bankName;
  String? bankAcronym;
  String? bankRif;
  String? bankAcquirerCode;
  String? bankThumbnail;
  Map<PaymentCardType, TransactionalChannel?>? bankTransactionalPaymentChannel;
  String? currencyCode;
  CurrencyInfo? currencyInfo;
  Map<TransactionType, String?>? terminals;
  Set<String>? terminalSet;

  MerchantAffiliation(
      {this.affiliationPetitionId,
      this.affiliationNumber,
      this.bankCode,
      this.bankName,
      this.bankAcronym,
      this.bankRif,
      this.bankAcquirerCode,
      this.bankThumbnail,
      this.bankTransactionalPaymentChannel,
      this.currencyCode,
      this.currencyInfo,
      this.terminals,
      this.terminalSet});

  factory MerchantAffiliation.fromJson(Map<String, dynamic> json) =>
      _$MerchantAffiliationFromJson(json);

  /// Connect the generated [_$MerchantAffiliationToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$MerchantAffiliationToJson(this);
}

enum PaymentCardType {
  TDD,
  TDC;
}

enum TransactionalChannel { CHANNEL_7_3, CHANNEL_7_7 }

enum TransactionType {
  CREDIT,
  DEBIT,
  AMEX,
  EXTRA_FINANCING;
}
