// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_colors.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

AppColors _$AppColorsFromJson(Map<String, dynamic> json) {
  return _AppColors.fromJson(json);
}

/// @nodoc
mixin _$AppColors {
  String get primary => throw _privateConstructorUsedError;
  String get primaryLight => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AppColorsCopyWith<AppColors> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppColorsCopyWith<$Res> {
  factory $AppColorsCopyWith(AppColors value, $Res Function(AppColors) then) =
      _$AppColorsCopyWithImpl<$Res, AppColors>;
  @useResult
  $Res call({String primary, String primaryLight});
}

/// @nodoc
class _$AppColorsCopyWithImpl<$Res, $Val extends AppColors>
    implements $AppColorsCopyWith<$Res> {
  _$AppColorsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? primary = null,
    Object? primaryLight = null,
  }) {
    return _then(_value.copyWith(
      primary: null == primary
          ? _value.primary
          : primary // ignore: cast_nullable_to_non_nullable
              as String,
      primaryLight: null == primaryLight
          ? _value.primaryLight
          : primaryLight // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AppColorsCopyWith<$Res> implements $AppColorsCopyWith<$Res> {
  factory _$$_AppColorsCopyWith(
          _$_AppColors value, $Res Function(_$_AppColors) then) =
      __$$_AppColorsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String primary, String primaryLight});
}

/// @nodoc
class __$$_AppColorsCopyWithImpl<$Res>
    extends _$AppColorsCopyWithImpl<$Res, _$_AppColors>
    implements _$$_AppColorsCopyWith<$Res> {
  __$$_AppColorsCopyWithImpl(
      _$_AppColors _value, $Res Function(_$_AppColors) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? primary = null,
    Object? primaryLight = null,
  }) {
    return _then(_$_AppColors(
      primary: null == primary
          ? _value.primary
          : primary // ignore: cast_nullable_to_non_nullable
              as String,
      primaryLight: null == primaryLight
          ? _value.primaryLight
          : primaryLight // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(
    explicitToJson: true, fieldRename: FieldRename.snake, includeIfNull: false)
class _$_AppColors with DiagnosticableTreeMixin implements _AppColors {
  const _$_AppColors({required this.primary, required this.primaryLight});

  factory _$_AppColors.fromJson(Map<String, dynamic> json) =>
      _$$_AppColorsFromJson(json);

  @override
  final String primary;
  @override
  final String primaryLight;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AppColors(primary: $primary, primaryLight: $primaryLight)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AppColors'))
      ..add(DiagnosticsProperty('primary', primary))
      ..add(DiagnosticsProperty('primaryLight', primaryLight));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AppColors &&
            (identical(other.primary, primary) || other.primary == primary) &&
            (identical(other.primaryLight, primaryLight) ||
                other.primaryLight == primaryLight));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, primary, primaryLight);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AppColorsCopyWith<_$_AppColors> get copyWith =>
      __$$_AppColorsCopyWithImpl<_$_AppColors>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AppColorsToJson(
      this,
    );
  }
}

abstract class _AppColors implements AppColors {
  const factory _AppColors(
      {required final String primary,
      required final String primaryLight}) = _$_AppColors;

  factory _AppColors.fromJson(Map<String, dynamic> json) =
      _$_AppColors.fromJson;

  @override
  String get primary;
  @override
  String get primaryLight;
  @override
  @JsonKey(ignore: true)
  _$$_AppColorsCopyWith<_$_AppColors> get copyWith =>
      throw _privateConstructorUsedError;
}
