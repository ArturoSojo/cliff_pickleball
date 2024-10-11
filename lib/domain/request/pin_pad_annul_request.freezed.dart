// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pin_pad_annul_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PinPadAnnulRequest _$PinPadAnnulRequestFromJson(Map<String, dynamic> json) {
  return _PinPadAnnulRequest.fromJson(json);
}

/// @nodoc
mixin _$PinPadAnnulRequest {
  Emv get emv => throw _privateConstructorUsedError;
  String get cardHolderId => throw _privateConstructorUsedError;
  ModePan get modePan => throw _privateConstructorUsedError;
  ModePin get modePin => throw _privateConstructorUsedError;
  PinPadCardInfoRequest get merchant => throw _privateConstructorUsedError;
  String get accountType => throw _privateConstructorUsedError;
  String get deviceIdentifier => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PinPadAnnulRequestCopyWith<PinPadAnnulRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PinPadAnnulRequestCopyWith<$Res> {
  factory $PinPadAnnulRequestCopyWith(
          PinPadAnnulRequest value, $Res Function(PinPadAnnulRequest) then) =
      _$PinPadAnnulRequestCopyWithImpl<$Res, PinPadAnnulRequest>;
  @useResult
  $Res call(
      {Emv emv,
      String cardHolderId,
      ModePan modePan,
      ModePin modePin,
      PinPadCardInfoRequest merchant,
      String accountType,
      String deviceIdentifier});

  $PinPadCardInfoRequestCopyWith<$Res> get merchant;
}

/// @nodoc
class _$PinPadAnnulRequestCopyWithImpl<$Res, $Val extends PinPadAnnulRequest>
    implements $PinPadAnnulRequestCopyWith<$Res> {
  _$PinPadAnnulRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? emv = null,
    Object? cardHolderId = null,
    Object? modePan = null,
    Object? modePin = null,
    Object? merchant = null,
    Object? accountType = null,
    Object? deviceIdentifier = null,
  }) {
    return _then(_value.copyWith(
      emv: null == emv
          ? _value.emv
          : emv // ignore: cast_nullable_to_non_nullable
              as Emv,
      cardHolderId: null == cardHolderId
          ? _value.cardHolderId
          : cardHolderId // ignore: cast_nullable_to_non_nullable
              as String,
      modePan: null == modePan
          ? _value.modePan
          : modePan // ignore: cast_nullable_to_non_nullable
              as ModePan,
      modePin: null == modePin
          ? _value.modePin
          : modePin // ignore: cast_nullable_to_non_nullable
              as ModePin,
      merchant: null == merchant
          ? _value.merchant
          : merchant // ignore: cast_nullable_to_non_nullable
              as PinPadCardInfoRequest,
      accountType: null == accountType
          ? _value.accountType
          : accountType // ignore: cast_nullable_to_non_nullable
              as String,
      deviceIdentifier: null == deviceIdentifier
          ? _value.deviceIdentifier
          : deviceIdentifier // ignore: cast_nullable_to_non_nullable
              as String,
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
abstract class _$$_PinPadAnnulRequestCopyWith<$Res>
    implements $PinPadAnnulRequestCopyWith<$Res> {
  factory _$$_PinPadAnnulRequestCopyWith(_$_PinPadAnnulRequest value,
          $Res Function(_$_PinPadAnnulRequest) then) =
      __$$_PinPadAnnulRequestCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Emv emv,
      String cardHolderId,
      ModePan modePan,
      ModePin modePin,
      PinPadCardInfoRequest merchant,
      String accountType,
      String deviceIdentifier});

  @override
  $PinPadCardInfoRequestCopyWith<$Res> get merchant;
}

/// @nodoc
class __$$_PinPadAnnulRequestCopyWithImpl<$Res>
    extends _$PinPadAnnulRequestCopyWithImpl<$Res, _$_PinPadAnnulRequest>
    implements _$$_PinPadAnnulRequestCopyWith<$Res> {
  __$$_PinPadAnnulRequestCopyWithImpl(
      _$_PinPadAnnulRequest _value, $Res Function(_$_PinPadAnnulRequest) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? emv = null,
    Object? cardHolderId = null,
    Object? modePan = null,
    Object? modePin = null,
    Object? merchant = null,
    Object? accountType = null,
    Object? deviceIdentifier = null,
  }) {
    return _then(_$_PinPadAnnulRequest(
      emv: null == emv
          ? _value.emv
          : emv // ignore: cast_nullable_to_non_nullable
              as Emv,
      cardHolderId: null == cardHolderId
          ? _value.cardHolderId
          : cardHolderId // ignore: cast_nullable_to_non_nullable
              as String,
      modePan: null == modePan
          ? _value.modePan
          : modePan // ignore: cast_nullable_to_non_nullable
              as ModePan,
      modePin: null == modePin
          ? _value.modePin
          : modePin // ignore: cast_nullable_to_non_nullable
              as ModePin,
      merchant: null == merchant
          ? _value.merchant
          : merchant // ignore: cast_nullable_to_non_nullable
              as PinPadCardInfoRequest,
      accountType: null == accountType
          ? _value.accountType
          : accountType // ignore: cast_nullable_to_non_nullable
              as String,
      deviceIdentifier: null == deviceIdentifier
          ? _value.deviceIdentifier
          : deviceIdentifier // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(
    explicitToJson: true, fieldRename: FieldRename.snake, includeIfNull: false)
class _$_PinPadAnnulRequest implements _PinPadAnnulRequest {
  const _$_PinPadAnnulRequest(
      {required this.emv,
      required this.cardHolderId,
      required this.modePan,
      required this.modePin,
      required this.merchant,
      required this.accountType,
      required this.deviceIdentifier});

  factory _$_PinPadAnnulRequest.fromJson(Map<String, dynamic> json) =>
      _$$_PinPadAnnulRequestFromJson(json);

  @override
  final Emv emv;
  @override
  final String cardHolderId;
  @override
  final ModePan modePan;
  @override
  final ModePin modePin;
  @override
  final PinPadCardInfoRequest merchant;
  @override
  final String accountType;
  @override
  final String deviceIdentifier;

  @override
  String toString() {
    return 'PinPadAnnulRequest(emv: $emv, cardHolderId: $cardHolderId, modePan: $modePan, modePin: $modePin, merchant: $merchant, accountType: $accountType, deviceIdentifier: $deviceIdentifier)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PinPadAnnulRequest &&
            (identical(other.emv, emv) || other.emv == emv) &&
            (identical(other.cardHolderId, cardHolderId) ||
                other.cardHolderId == cardHolderId) &&
            (identical(other.modePan, modePan) || other.modePan == modePan) &&
            (identical(other.modePin, modePin) || other.modePin == modePin) &&
            (identical(other.merchant, merchant) ||
                other.merchant == merchant) &&
            (identical(other.accountType, accountType) ||
                other.accountType == accountType) &&
            (identical(other.deviceIdentifier, deviceIdentifier) ||
                other.deviceIdentifier == deviceIdentifier));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, emv, cardHolderId, modePan,
      modePin, merchant, accountType, deviceIdentifier);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PinPadAnnulRequestCopyWith<_$_PinPadAnnulRequest> get copyWith =>
      __$$_PinPadAnnulRequestCopyWithImpl<_$_PinPadAnnulRequest>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PinPadAnnulRequestToJson(
      this,
    );
  }
}

abstract class _PinPadAnnulRequest implements PinPadAnnulRequest {
  const factory _PinPadAnnulRequest(
      {required final Emv emv,
      required final String cardHolderId,
      required final ModePan modePan,
      required final ModePin modePin,
      required final PinPadCardInfoRequest merchant,
      required final String accountType,
      required final String deviceIdentifier}) = _$_PinPadAnnulRequest;

  factory _PinPadAnnulRequest.fromJson(Map<String, dynamic> json) =
      _$_PinPadAnnulRequest.fromJson;

  @override
  Emv get emv;
  @override
  String get cardHolderId;
  @override
  ModePan get modePan;
  @override
  ModePin get modePin;
  @override
  PinPadCardInfoRequest get merchant;
  @override
  String get accountType;
  @override
  String get deviceIdentifier;
  @override
  @JsonKey(ignore: true)
  _$$_PinPadAnnulRequestCopyWith<_$_PinPadAnnulRequest> get copyWith =>
      throw _privateConstructorUsedError;
}
