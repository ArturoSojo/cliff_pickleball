// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

DeviceBluetooth _$DeviceBluetoothFromJson(Map<String, dynamic> json) {
  return _DeviceBluetooth.fromJson(json);
}

/// @nodoc
mixin _$DeviceBluetooth {
  String get name => throw _privateConstructorUsedError;
  String get macAddress => throw _privateConstructorUsedError;
  String? get id => throw _privateConstructorUsedError;
  int? get p => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DeviceBluetoothCopyWith<DeviceBluetooth> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceBluetoothCopyWith<$Res> {
  factory $DeviceBluetoothCopyWith(
          DeviceBluetooth value, $Res Function(DeviceBluetooth) then) =
      _$DeviceBluetoothCopyWithImpl<$Res, DeviceBluetooth>;
  @useResult
  $Res call({String name, String macAddress, String? id, int? p});
}

/// @nodoc
class _$DeviceBluetoothCopyWithImpl<$Res, $Val extends DeviceBluetooth>
    implements $DeviceBluetoothCopyWith<$Res> {
  _$DeviceBluetoothCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? macAddress = null,
    Object? id = freezed,
    Object? p = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      macAddress: null == macAddress
          ? _value.macAddress
          : macAddress // ignore: cast_nullable_to_non_nullable
              as String,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      p: freezed == p
          ? _value.p
          : p // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_DeviceBluetoothCopyWith<$Res>
    implements $DeviceBluetoothCopyWith<$Res> {
  factory _$$_DeviceBluetoothCopyWith(
          _$_DeviceBluetooth value, $Res Function(_$_DeviceBluetooth) then) =
      __$$_DeviceBluetoothCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String macAddress, String? id, int? p});
}

/// @nodoc
class __$$_DeviceBluetoothCopyWithImpl<$Res>
    extends _$DeviceBluetoothCopyWithImpl<$Res, _$_DeviceBluetooth>
    implements _$$_DeviceBluetoothCopyWith<$Res> {
  __$$_DeviceBluetoothCopyWithImpl(
      _$_DeviceBluetooth _value, $Res Function(_$_DeviceBluetooth) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? macAddress = null,
    Object? id = freezed,
    Object? p = freezed,
  }) {
    return _then(_$_DeviceBluetooth(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      macAddress: null == macAddress
          ? _value.macAddress
          : macAddress // ignore: cast_nullable_to_non_nullable
              as String,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      p: freezed == p
          ? _value.p
          : p // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

@JsonSerializable(
    explicitToJson: true, fieldRename: FieldRename.snake, includeIfNull: false)
class _$_DeviceBluetooth implements _DeviceBluetooth {
  const _$_DeviceBluetooth(
      {required this.name, required this.macAddress, this.id, this.p});

  factory _$_DeviceBluetooth.fromJson(Map<String, dynamic> json) =>
      _$$_DeviceBluetoothFromJson(json);

  @override
  final String name;
  @override
  final String macAddress;
  @override
  final String? id;
  @override
  final int? p;

  @override
  String toString() {
    return 'DeviceBluetooth(name: $name, macAddress: $macAddress, id: $id, p: $p)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_DeviceBluetooth &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.macAddress, macAddress) ||
                other.macAddress == macAddress) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.p, p) || other.p == p));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, macAddress, id, p);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_DeviceBluetoothCopyWith<_$_DeviceBluetooth> get copyWith =>
      __$$_DeviceBluetoothCopyWithImpl<_$_DeviceBluetooth>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_DeviceBluetoothToJson(
      this,
    );
  }
}

abstract class _DeviceBluetooth implements DeviceBluetooth {
  const factory _DeviceBluetooth(
      {required final String name,
      required final String macAddress,
      final String? id,
      final int? p}) = _$_DeviceBluetooth;

  factory _DeviceBluetooth.fromJson(Map<String, dynamic> json) =
      _$_DeviceBluetooth.fromJson;

  @override
  String get name;
  @override
  String get macAddress;
  @override
  String? get id;
  @override
  int? get p;
  @override
  @JsonKey(ignore: true)
  _$$_DeviceBluetoothCopyWith<_$_DeviceBluetooth> get copyWith =>
      throw _privateConstructorUsedError;
}
