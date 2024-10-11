// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pin_pad_payment_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PinPadPaymentRequest _$PinPadPaymentRequestFromJson(Map<String, dynamic> json) {
  return _PinPadPaymentRequest.fromJson(json);
}

/// @nodoc
mixin _$PinPadPaymentRequest {
  Emv get emv => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String? get operationDescription => throw _privateConstructorUsedError;
  AccountType get accountType => throw _privateConstructorUsedError;
  String get deviceIdentifier => throw _privateConstructorUsedError;
  String? get externalReference => throw _privateConstructorUsedError;
  String get cardHolderId => throw _privateConstructorUsedError;
  IdType get cardHolderIdType => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  ModePan get modePan => throw _privateConstructorUsedError;
  ModePin get modePin => throw _privateConstructorUsedError;
  PaymentCardType get paymentCardType => throw _privateConstructorUsedError;
  String? get payerName => throw _privateConstructorUsedError;
  PinPadCardInfoRequest get merchant => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PinPadPaymentRequestCopyWith<PinPadPaymentRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PinPadPaymentRequestCopyWith<$Res> {
  factory $PinPadPaymentRequestCopyWith(PinPadPaymentRequest value,
          $Res Function(PinPadPaymentRequest) then) =
      _$PinPadPaymentRequestCopyWithImpl<$Res, PinPadPaymentRequest>;
  @useResult
  $Res call(
      {Emv emv,
      double amount,
      String? operationDescription,
      AccountType accountType,
      String deviceIdentifier,
      String? externalReference,
      String cardHolderId,
      IdType cardHolderIdType,
      String currency,
      ModePan modePan,
      ModePin modePin,
      PaymentCardType paymentCardType,
      String? payerName,
      PinPadCardInfoRequest merchant});

  $PinPadCardInfoRequestCopyWith<$Res> get merchant;
}

/// @nodoc
class _$PinPadPaymentRequestCopyWithImpl<$Res,
        $Val extends PinPadPaymentRequest>
    implements $PinPadPaymentRequestCopyWith<$Res> {
  _$PinPadPaymentRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? emv = null,
    Object? amount = null,
    Object? operationDescription = freezed,
    Object? accountType = null,
    Object? deviceIdentifier = null,
    Object? externalReference = freezed,
    Object? cardHolderId = null,
    Object? cardHolderIdType = null,
    Object? currency = null,
    Object? modePan = null,
    Object? modePin = null,
    Object? paymentCardType = null,
    Object? payerName = freezed,
    Object? merchant = null,
  }) {
    return _then(_value.copyWith(
      emv: null == emv
          ? _value.emv
          : emv // ignore: cast_nullable_to_non_nullable
              as Emv,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      operationDescription: freezed == operationDescription
          ? _value.operationDescription
          : operationDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      accountType: null == accountType
          ? _value.accountType
          : accountType // ignore: cast_nullable_to_non_nullable
              as AccountType,
      deviceIdentifier: null == deviceIdentifier
          ? _value.deviceIdentifier
          : deviceIdentifier // ignore: cast_nullable_to_non_nullable
              as String,
      externalReference: freezed == externalReference
          ? _value.externalReference
          : externalReference // ignore: cast_nullable_to_non_nullable
              as String?,
      cardHolderId: null == cardHolderId
          ? _value.cardHolderId
          : cardHolderId // ignore: cast_nullable_to_non_nullable
              as String,
      cardHolderIdType: null == cardHolderIdType
          ? _value.cardHolderIdType
          : cardHolderIdType // ignore: cast_nullable_to_non_nullable
              as IdType,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      modePan: null == modePan
          ? _value.modePan
          : modePan // ignore: cast_nullable_to_non_nullable
              as ModePan,
      modePin: null == modePin
          ? _value.modePin
          : modePin // ignore: cast_nullable_to_non_nullable
              as ModePin,
      paymentCardType: null == paymentCardType
          ? _value.paymentCardType
          : paymentCardType // ignore: cast_nullable_to_non_nullable
              as PaymentCardType,
      payerName: freezed == payerName
          ? _value.payerName
          : payerName // ignore: cast_nullable_to_non_nullable
              as String?,
      merchant: null == merchant
          ? _value.merchant
          : merchant // ignore: cast_nullable_to_non_nullable
              as PinPadCardInfoRequest,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PinPadCardInfoRequestCopyWith<$Res> get merchant {
    return $PinPadCardInfoRequestCopyWith<$Res>(_value.merchant, (value) {
      return _then(_value.copyWith(merchant: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_PinPadPaymentRequestCopyWith<$Res>
    implements $PinPadPaymentRequestCopyWith<$Res> {
  factory _$$_PinPadPaymentRequestCopyWith(_$_PinPadPaymentRequest value,
          $Res Function(_$_PinPadPaymentRequest) then) =
      __$$_PinPadPaymentRequestCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Emv emv,
      double amount,
      String? operationDescription,
      AccountType accountType,
      String deviceIdentifier,
      String? externalReference,
      String cardHolderId,
      IdType cardHolderIdType,
      String currency,
      ModePan modePan,
      ModePin modePin,
      PaymentCardType paymentCardType,
      String? payerName,
      PinPadCardInfoRequest merchant});

  @override
  $PinPadCardInfoRequestCopyWith<$Res> get merchant;
}

/// @nodoc
class __$$_PinPadPaymentRequestCopyWithImpl<$Res>
    extends _$PinPadPaymentRequestCopyWithImpl<$Res, _$_PinPadPaymentRequest>
    implements _$$_PinPadPaymentRequestCopyWith<$Res> {
  __$$_PinPadPaymentRequestCopyWithImpl(_$_PinPadPaymentRequest _value,
      $Res Function(_$_PinPadPaymentRequest) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? emv = null,
    Object? amount = null,
    Object? operationDescription = freezed,
    Object? accountType = null,
    Object? deviceIdentifier = null,
    Object? externalReference = freezed,
    Object? cardHolderId = null,
    Object? cardHolderIdType = null,
    Object? currency = null,
    Object? modePan = null,
    Object? modePin = null,
    Object? paymentCardType = null,
    Object? payerName = freezed,
    Object? merchant = null,
  }) {
    return _then(_$_PinPadPaymentRequest(
      emv: null == emv
          ? _value.emv
          : emv // ignore: cast_nullable_to_non_nullable
              as Emv,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      operationDescription: freezed == operationDescription
          ? _value.operationDescription
          : operationDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      accountType: null == accountType
          ? _value.accountType
          : accountType // ignore: cast_nullable_to_non_nullable
              as AccountType,
      deviceIdentifier: null == deviceIdentifier
          ? _value.deviceIdentifier
          : deviceIdentifier // ignore: cast_nullable_to_non_nullable
              as String,
      externalReference: freezed == externalReference
          ? _value.externalReference
          : externalReference // ignore: cast_nullable_to_non_nullable
              as String?,
      cardHolderId: null == cardHolderId
          ? _value.cardHolderId
          : cardHolderId // ignore: cast_nullable_to_non_nullable
              as String,
      cardHolderIdType: null == cardHolderIdType
          ? _value.cardHolderIdType
          : cardHolderIdType // ignore: cast_nullable_to_non_nullable
              as IdType,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      modePan: null == modePan
          ? _value.modePan
          : modePan // ignore: cast_nullable_to_non_nullable
              as ModePan,
      modePin: null == modePin
          ? _value.modePin
          : modePin // ignore: cast_nullable_to_non_nullable
              as ModePin,
      paymentCardType: null == paymentCardType
          ? _value.paymentCardType
          : paymentCardType // ignore: cast_nullable_to_non_nullable
              as PaymentCardType,
      payerName: freezed == payerName
          ? _value.payerName
          : payerName // ignore: cast_nullable_to_non_nullable
              as String?,
      merchant: null == merchant
          ? _value.merchant
          : merchant // ignore: cast_nullable_to_non_nullable
              as PinPadCardInfoRequest,
    ));
  }
}

/// @nodoc

@JsonSerializable(
    explicitToJson: true, fieldRename: FieldRename.snake, includeIfNull: false)
class _$_PinPadPaymentRequest
    with DiagnosticableTreeMixin
    implements _PinPadPaymentRequest {
  const _$_PinPadPaymentRequest(
      {required this.emv,
      required this.amount,
      this.operationDescription,
      required this.accountType,
      required this.deviceIdentifier,
      this.externalReference,
      required this.cardHolderId,
      required this.cardHolderIdType,
      required this.currency,
      required this.modePan,
      required this.modePin,
      required this.paymentCardType,
      this.payerName,
      required this.merchant});

  factory _$_PinPadPaymentRequest.fromJson(Map<String, dynamic> json) =>
      _$$_PinPadPaymentRequestFromJson(json);

  @override
  final Emv emv;
  @override
  final double amount;
  @override
  final String? operationDescription;
  @override
  final AccountType accountType;
  @override
  final String deviceIdentifier;
  @override
  final String? externalReference;
  @override
  final String cardHolderId;
  @override
  final IdType cardHolderIdType;
  @override
  final String currency;
  @override
  final ModePan modePan;
  @override
  final ModePin modePin;
  @override
  final PaymentCardType paymentCardType;
  @override
  final String? payerName;
  @override
  final PinPadCardInfoRequest merchant;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PinPadPaymentRequest(emv: $emv, amount: $amount, operationDescription: $operationDescription, accountType: $accountType, deviceIdentifier: $deviceIdentifier, externalReference: $externalReference, cardHolderId: $cardHolderId, cardHolderIdType: $cardHolderIdType, currency: $currency, modePan: $modePan, modePin: $modePin, paymentCardType: $paymentCardType, payerName: $payerName, merchant: $merchant)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PinPadPaymentRequest'))
      ..add(DiagnosticsProperty('emv', emv))
      ..add(DiagnosticsProperty('amount', amount))
      ..add(DiagnosticsProperty('operationDescription', operationDescription))
      ..add(DiagnosticsProperty('accountType', accountType))
      ..add(DiagnosticsProperty('deviceIdentifier', deviceIdentifier))
      ..add(DiagnosticsProperty('externalReference', externalReference))
      ..add(DiagnosticsProperty('cardHolderId', cardHolderId))
      ..add(DiagnosticsProperty('cardHolderIdType', cardHolderIdType))
      ..add(DiagnosticsProperty('currency', currency))
      ..add(DiagnosticsProperty('modePan', modePan))
      ..add(DiagnosticsProperty('modePin', modePin))
      ..add(DiagnosticsProperty('paymentCardType', paymentCardType))
      ..add(DiagnosticsProperty('payerName', payerName))
      ..add(DiagnosticsProperty('merchant', merchant));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PinPadPaymentRequest &&
            (identical(other.emv, emv) || other.emv == emv) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.operationDescription, operationDescription) ||
                other.operationDescription == operationDescription) &&
            (identical(other.accountType, accountType) ||
                other.accountType == accountType) &&
            (identical(other.deviceIdentifier, deviceIdentifier) ||
                other.deviceIdentifier == deviceIdentifier) &&
            (identical(other.externalReference, externalReference) ||
                other.externalReference == externalReference) &&
            (identical(other.cardHolderId, cardHolderId) ||
                other.cardHolderId == cardHolderId) &&
            (identical(other.cardHolderIdType, cardHolderIdType) ||
                other.cardHolderIdType == cardHolderIdType) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.modePan, modePan) || other.modePan == modePan) &&
            (identical(other.modePin, modePin) || other.modePin == modePin) &&
            (identical(other.paymentCardType, paymentCardType) ||
                other.paymentCardType == paymentCardType) &&
            (identical(other.payerName, payerName) ||
                other.payerName == payerName) &&
            (identical(other.merchant, merchant) ||
                other.merchant == merchant));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      emv,
      amount,
      operationDescription,
      accountType,
      deviceIdentifier,
      externalReference,
      cardHolderId,
      cardHolderIdType,
      currency,
      modePan,
      modePin,
      paymentCardType,
      payerName,
      merchant);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PinPadPaymentRequestCopyWith<_$_PinPadPaymentRequest> get copyWith =>
      __$$_PinPadPaymentRequestCopyWithImpl<_$_PinPadPaymentRequest>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PinPadPaymentRequestToJson(
      this,
    );
  }
}

abstract class _PinPadPaymentRequest implements PinPadPaymentRequest {
  const factory _PinPadPaymentRequest(
      {required final Emv emv,
      required final double amount,
      final String? operationDescription,
      required final AccountType accountType,
      required final String deviceIdentifier,
      final String? externalReference,
      required final String cardHolderId,
      required final IdType cardHolderIdType,
      required final String currency,
      required final ModePan modePan,
      required final ModePin modePin,
      required final PaymentCardType paymentCardType,
      final String? payerName,
      required final PinPadCardInfoRequest merchant}) = _$_PinPadPaymentRequest;

  factory _PinPadPaymentRequest.fromJson(Map<String, dynamic> json) =
      _$_PinPadPaymentRequest.fromJson;

  @override
  Emv get emv;
  @override
  double get amount;
  @override
  String? get operationDescription;
  @override
  AccountType get accountType;
  @override
  String get deviceIdentifier;
  @override
  String? get externalReference;
  @override
  String get cardHolderId;
  @override
  IdType get cardHolderIdType;
  @override
  String get currency;
  @override
  ModePan get modePan;
  @override
  ModePin get modePin;
  @override
  PaymentCardType get paymentCardType;
  @override
  String? get payerName;
  @override
  PinPadCardInfoRequest get merchant;
  @override
  @JsonKey(ignore: true)
  _$$_PinPadPaymentRequestCopyWith<_$_PinPadPaymentRequest> get copyWith =>
      throw _privateConstructorUsedError;
}
