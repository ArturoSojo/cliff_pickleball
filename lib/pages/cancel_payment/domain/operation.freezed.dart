// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'operation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Operation _$OperationFromJson(Map<String, dynamic> json) {
  return _Operation.fromJson(json);
}

/// @nodoc
mixin _$Operation {
  String get id =>
      throw _privateConstructorUsedError; //required String orderId,
  String get lotNumber => throw _privateConstructorUsedError;
  String get accountType => throw _privateConstructorUsedError;
  String get affiliationNumber => throw _privateConstructorUsedError;
  String get amount => throw _privateConstructorUsedError;
  String get cardHolderId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OperationCopyWith<Operation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OperationCopyWith<$Res> {
  factory $OperationCopyWith(Operation value, $Res Function(Operation) then) =
      _$OperationCopyWithImpl<$Res, Operation>;
  @useResult
  $Res call(
      {String id,
      String lotNumber,
      String accountType,
      String affiliationNumber,
      String amount,
      String cardHolderId});
}

/// @nodoc
class _$OperationCopyWithImpl<$Res, $Val extends Operation>
    implements $OperationCopyWith<$Res> {
  _$OperationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? lotNumber = null,
    Object? accountType = null,
    Object? affiliationNumber = null,
    Object? amount = null,
    Object? cardHolderId = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      lotNumber: null == lotNumber
          ? _value.lotNumber
          : lotNumber // ignore: cast_nullable_to_non_nullable
              as String,
      accountType: null == accountType
          ? _value.accountType
          : accountType // ignore: cast_nullable_to_non_nullable
              as String,
      affiliationNumber: null == affiliationNumber
          ? _value.affiliationNumber
          : affiliationNumber // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String,
      cardHolderId: null == cardHolderId
          ? _value.cardHolderId
          : cardHolderId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_OperationCopyWith<$Res> implements $OperationCopyWith<$Res> {
  factory _$$_OperationCopyWith(
          _$_Operation value, $Res Function(_$_Operation) then) =
      __$$_OperationCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String lotNumber,
      String accountType,
      String affiliationNumber,
      String amount,
      String cardHolderId});
}

/// @nodoc
class __$$_OperationCopyWithImpl<$Res>
    extends _$OperationCopyWithImpl<$Res, _$_Operation>
    implements _$$_OperationCopyWith<$Res> {
  __$$_OperationCopyWithImpl(
      _$_Operation _value, $Res Function(_$_Operation) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? lotNumber = null,
    Object? accountType = null,
    Object? affiliationNumber = null,
    Object? amount = null,
    Object? cardHolderId = null,
  }) {
    return _then(_$_Operation(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      lotNumber: null == lotNumber
          ? _value.lotNumber
          : lotNumber // ignore: cast_nullable_to_non_nullable
              as String,
      accountType: null == accountType
          ? _value.accountType
          : accountType // ignore: cast_nullable_to_non_nullable
              as String,
      affiliationNumber: null == affiliationNumber
          ? _value.affiliationNumber
          : affiliationNumber // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String,
      cardHolderId: null == cardHolderId
          ? _value.cardHolderId
          : cardHolderId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(
    explicitToJson: true, fieldRename: FieldRename.snake, includeIfNull: false)
class _$_Operation implements _Operation {
  const _$_Operation(
      {required this.id,
      required this.lotNumber,
      required this.accountType,
      required this.affiliationNumber,
      required this.amount,
      required this.cardHolderId});

  factory _$_Operation.fromJson(Map<String, dynamic> json) =>
      _$$_OperationFromJson(json);

  @override
  final String id;
//required String orderId,
  @override
  final String lotNumber;
  @override
  final String accountType;
  @override
  final String affiliationNumber;
  @override
  final String amount;
  @override
  final String cardHolderId;

  @override
  String toString() {
    return 'Operation(id: $id, lotNumber: $lotNumber, accountType: $accountType, affiliationNumber: $affiliationNumber, amount: $amount, cardHolderId: $cardHolderId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Operation &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.lotNumber, lotNumber) ||
                other.lotNumber == lotNumber) &&
            (identical(other.accountType, accountType) ||
                other.accountType == accountType) &&
            (identical(other.affiliationNumber, affiliationNumber) ||
                other.affiliationNumber == affiliationNumber) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.cardHolderId, cardHolderId) ||
                other.cardHolderId == cardHolderId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, lotNumber, accountType,
      affiliationNumber, amount, cardHolderId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_OperationCopyWith<_$_Operation> get copyWith =>
      __$$_OperationCopyWithImpl<_$_Operation>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_OperationToJson(
      this,
    );
  }
}

abstract class _Operation implements Operation {
  const factory _Operation(
      {required final String id,
      required final String lotNumber,
      required final String accountType,
      required final String affiliationNumber,
      required final String amount,
      required final String cardHolderId}) = _$_Operation;

  factory _Operation.fromJson(Map<String, dynamic> json) =
      _$_Operation.fromJson;

  @override
  String get id;
  @override //required String orderId,
  String get lotNumber;
  @override
  String get accountType;
  @override
  String get affiliationNumber;
  @override
  String get amount;
  @override
  String get cardHolderId;
  @override
  @JsonKey(ignore: true)
  _$$_OperationCopyWith<_$_Operation> get copyWith =>
      throw _privateConstructorUsedError;
}
