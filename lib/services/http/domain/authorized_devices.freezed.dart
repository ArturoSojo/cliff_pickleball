// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'authorized_devices.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

AuthorizedDevices _$AuthorizedDevicesFromJson(Map<String, dynamic> json) {
  return _AuthorizedDevices.fromJson(json);
}

/// @nodoc
mixin _$AuthorizedDevices {
  Map<String, bool> get map => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AuthorizedDevicesCopyWith<AuthorizedDevices> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthorizedDevicesCopyWith<$Res> {
  factory $AuthorizedDevicesCopyWith(
          AuthorizedDevices value, $Res Function(AuthorizedDevices) then) =
      _$AuthorizedDevicesCopyWithImpl<$Res, AuthorizedDevices>;
  @useResult
  $Res call({Map<String, bool> map});
}

/// @nodoc
class _$AuthorizedDevicesCopyWithImpl<$Res, $Val extends AuthorizedDevices>
    implements $AuthorizedDevicesCopyWith<$Res> {
  _$AuthorizedDevicesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? map = null,
  }) {
    return _then(_value.copyWith(
      map: null == map
          ? _value.map
          : map // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AuthorizedDevicesCopyWith<$Res>
    implements $AuthorizedDevicesCopyWith<$Res> {
  factory _$$_AuthorizedDevicesCopyWith(_$_AuthorizedDevices value,
          $Res Function(_$_AuthorizedDevices) then) =
      __$$_AuthorizedDevicesCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<String, bool> map});
}

/// @nodoc
class __$$_AuthorizedDevicesCopyWithImpl<$Res>
    extends _$AuthorizedDevicesCopyWithImpl<$Res, _$_AuthorizedDevices>
    implements _$$_AuthorizedDevicesCopyWith<$Res> {
  __$$_AuthorizedDevicesCopyWithImpl(
      _$_AuthorizedDevices _value, $Res Function(_$_AuthorizedDevices) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? map = null,
  }) {
    return _then(_$_AuthorizedDevices(
      map: null == map
          ? _value._map
          : map // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
    ));
  }
}

/// @nodoc

@JsonSerializable(
    explicitToJson: true, fieldRename: FieldRename.snake, includeIfNull: false)
class _$_AuthorizedDevices
    with DiagnosticableTreeMixin
    implements _AuthorizedDevices {
  const _$_AuthorizedDevices({required final Map<String, bool> map})
      : _map = map;

  factory _$_AuthorizedDevices.fromJson(Map<String, dynamic> json) =>
      _$$_AuthorizedDevicesFromJson(json);

  final Map<String, bool> _map;
  @override
  Map<String, bool> get map {
    if (_map is EqualUnmodifiableMapView) return _map;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_map);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AuthorizedDevices(map: $map)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AuthorizedDevices'))
      ..add(DiagnosticsProperty('map', map));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AuthorizedDevices &&
            const DeepCollectionEquality().equals(other._map, _map));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_map));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AuthorizedDevicesCopyWith<_$_AuthorizedDevices> get copyWith =>
      __$$_AuthorizedDevicesCopyWithImpl<_$_AuthorizedDevices>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AuthorizedDevicesToJson(
      this,
    );
  }
}

abstract class _AuthorizedDevices implements AuthorizedDevices {
  const factory _AuthorizedDevices({required final Map<String, bool> map}) =
      _$_AuthorizedDevices;

  factory _AuthorizedDevices.fromJson(Map<String, dynamic> json) =
      _$_AuthorizedDevices.fromJson;

  @override
  Map<String, bool> get map;
  @override
  @JsonKey(ignore: true)
  _$$_AuthorizedDevicesCopyWith<_$_AuthorizedDevices> get copyWith =>
      throw _privateConstructorUsedError;
}
