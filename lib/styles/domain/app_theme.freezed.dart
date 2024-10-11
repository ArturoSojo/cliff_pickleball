// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_theme.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

AppTheme _$AppThemeFromJson(Map<String, dynamic> json) {
  return _AppTheme.fromJson(json);
}

/// @nodoc
mixin _$AppTheme {
  String get name => throw _privateConstructorUsedError;
  bool get dflt => throw _privateConstructorUsedError;
  Filter get filter => throw _privateConstructorUsedError;
  AppColors get colors => throw _privateConstructorUsedError;
  AppAssets get assetsImg => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AppThemeCopyWith<AppTheme> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppThemeCopyWith<$Res> {
  factory $AppThemeCopyWith(AppTheme value, $Res Function(AppTheme) then) =
      _$AppThemeCopyWithImpl<$Res, AppTheme>;
  @useResult
  $Res call(
      {String name,
      bool dflt,
      Filter filter,
      AppColors colors,
      AppAssets assetsImg});

  $FilterCopyWith<$Res> get filter;
  $AppColorsCopyWith<$Res> get colors;
  $AppAssetsCopyWith<$Res> get assetsImg;
}

/// @nodoc
class _$AppThemeCopyWithImpl<$Res, $Val extends AppTheme>
    implements $AppThemeCopyWith<$Res> {
  _$AppThemeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? dflt = null,
    Object? filter = null,
    Object? colors = null,
    Object? assetsImg = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      dflt: null == dflt
          ? _value.dflt
          : dflt // ignore: cast_nullable_to_non_nullable
              as bool,
      filter: null == filter
          ? _value.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as Filter,
      colors: null == colors
          ? _value.colors
          : colors // ignore: cast_nullable_to_non_nullable
              as AppColors,
      assetsImg: null == assetsImg
          ? _value.assetsImg
          : assetsImg // ignore: cast_nullable_to_non_nullable
              as AppAssets,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $FilterCopyWith<$Res> get filter {
    return $FilterCopyWith<$Res>(_value.filter, (value) {
      return _then(_value.copyWith(filter: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $AppColorsCopyWith<$Res> get colors {
    return $AppColorsCopyWith<$Res>(_value.colors, (value) {
      return _then(_value.copyWith(colors: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $AppAssetsCopyWith<$Res> get assetsImg {
    return $AppAssetsCopyWith<$Res>(_value.assetsImg, (value) {
      return _then(_value.copyWith(assetsImg: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_AppThemeCopyWith<$Res> implements $AppThemeCopyWith<$Res> {
  factory _$$_AppThemeCopyWith(
          _$_AppTheme value, $Res Function(_$_AppTheme) then) =
      __$$_AppThemeCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      bool dflt,
      Filter filter,
      AppColors colors,
      AppAssets assetsImg});

  @override
  $FilterCopyWith<$Res> get filter;
  @override
  $AppColorsCopyWith<$Res> get colors;
  @override
  $AppAssetsCopyWith<$Res> get assetsImg;
}

/// @nodoc
class __$$_AppThemeCopyWithImpl<$Res>
    extends _$AppThemeCopyWithImpl<$Res, _$_AppTheme>
    implements _$$_AppThemeCopyWith<$Res> {
  __$$_AppThemeCopyWithImpl(
      _$_AppTheme _value, $Res Function(_$_AppTheme) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? dflt = null,
    Object? filter = null,
    Object? colors = null,
    Object? assetsImg = null,
  }) {
    return _then(_$_AppTheme(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      dflt: null == dflt
          ? _value.dflt
          : dflt // ignore: cast_nullable_to_non_nullable
              as bool,
      filter: null == filter
          ? _value.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as Filter,
      colors: null == colors
          ? _value.colors
          : colors // ignore: cast_nullable_to_non_nullable
              as AppColors,
      assetsImg: null == assetsImg
          ? _value.assetsImg
          : assetsImg // ignore: cast_nullable_to_non_nullable
              as AppAssets,
    ));
  }
}

/// @nodoc

@JsonSerializable(
    explicitToJson: true, fieldRename: FieldRename.snake, includeIfNull: false)
class _$_AppTheme with DiagnosticableTreeMixin implements _AppTheme {
  const _$_AppTheme(
      {required this.name,
      this.dflt = false,
      required this.filter,
      required this.colors,
      required this.assetsImg});

  factory _$_AppTheme.fromJson(Map<String, dynamic> json) =>
      _$$_AppThemeFromJson(json);

  @override
  final String name;
  @override
  @JsonKey()
  final bool dflt;
  @override
  final Filter filter;
  @override
  final AppColors colors;
  @override
  final AppAssets assetsImg;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AppTheme(name: $name, dflt: $dflt, filter: $filter, colors: $colors, assetsImg: $assetsImg)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AppTheme'))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('dflt', dflt))
      ..add(DiagnosticsProperty('filter', filter))
      ..add(DiagnosticsProperty('colors', colors))
      ..add(DiagnosticsProperty('assetsImg', assetsImg));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AppTheme &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.dflt, dflt) || other.dflt == dflt) &&
            (identical(other.filter, filter) || other.filter == filter) &&
            (identical(other.colors, colors) || other.colors == colors) &&
            (identical(other.assetsImg, assetsImg) ||
                other.assetsImg == assetsImg));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, dflt, filter, colors, assetsImg);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AppThemeCopyWith<_$_AppTheme> get copyWith =>
      __$$_AppThemeCopyWithImpl<_$_AppTheme>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AppThemeToJson(
      this,
    );
  }
}

abstract class _AppTheme implements AppTheme {
  const factory _AppTheme(
      {required final String name,
      final bool dflt,
      required final Filter filter,
      required final AppColors colors,
      required final AppAssets assetsImg}) = _$_AppTheme;

  factory _AppTheme.fromJson(Map<String, dynamic> json) = _$_AppTheme.fromJson;

  @override
  String get name;
  @override
  bool get dflt;
  @override
  Filter get filter;
  @override
  AppColors get colors;
  @override
  AppAssets get assetsImg;
  @override
  @JsonKey(ignore: true)
  _$$_AppThemeCopyWith<_$_AppTheme> get copyWith =>
      throw _privateConstructorUsedError;
}
