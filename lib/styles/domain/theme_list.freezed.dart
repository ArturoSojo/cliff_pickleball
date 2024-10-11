// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theme_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ThemeList _$ThemeListFromJson(Map<String, dynamic> json) {
  return _ThemeList.fromJson(json);
}

/// @nodoc
mixin _$ThemeList {
  List<AppTheme> get list => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ThemeListCopyWith<ThemeList> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ThemeListCopyWith<$Res> {
  factory $ThemeListCopyWith(ThemeList value, $Res Function(ThemeList) then) =
      _$ThemeListCopyWithImpl<$Res, ThemeList>;
  @useResult
  $Res call({List<AppTheme> list});
}

/// @nodoc
class _$ThemeListCopyWithImpl<$Res, $Val extends ThemeList>
    implements $ThemeListCopyWith<$Res> {
  _$ThemeListCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
  }) {
    return _then(_value.copyWith(
      list: null == list
          ? _value.list
          : list // ignore: cast_nullable_to_non_nullable
              as List<AppTheme>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ThemeListCopyWith<$Res> implements $ThemeListCopyWith<$Res> {
  factory _$$_ThemeListCopyWith(
          _$_ThemeList value, $Res Function(_$_ThemeList) then) =
      __$$_ThemeListCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<AppTheme> list});
}

/// @nodoc
class __$$_ThemeListCopyWithImpl<$Res>
    extends _$ThemeListCopyWithImpl<$Res, _$_ThemeList>
    implements _$$_ThemeListCopyWith<$Res> {
  __$$_ThemeListCopyWithImpl(
      _$_ThemeList _value, $Res Function(_$_ThemeList) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
  }) {
    return _then(_$_ThemeList(
      list: null == list
          ? _value._list
          : list // ignore: cast_nullable_to_non_nullable
              as List<AppTheme>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ThemeList with DiagnosticableTreeMixin implements _ThemeList {
  const _$_ThemeList({required final List<AppTheme> list}) : _list = list;

  factory _$_ThemeList.fromJson(Map<String, dynamic> json) =>
      _$$_ThemeListFromJson(json);

  final List<AppTheme> _list;
  @override
  List<AppTheme> get list {
    if (_list is EqualUnmodifiableListView) return _list;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_list);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ThemeList(list: $list)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ThemeList'))
      ..add(DiagnosticsProperty('list', list));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ThemeList &&
            const DeepCollectionEquality().equals(other._list, _list));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_list));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ThemeListCopyWith<_$_ThemeList> get copyWith =>
      __$$_ThemeListCopyWithImpl<_$_ThemeList>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ThemeListToJson(
      this,
    );
  }
}

abstract class _ThemeList implements ThemeList {
  const factory _ThemeList({required final List<AppTheme> list}) = _$_ThemeList;

  factory _ThemeList.fromJson(Map<String, dynamic> json) =
      _$_ThemeList.fromJson;

  @override
  List<AppTheme> get list;
  @override
  @JsonKey(ignore: true)
  _$$_ThemeListCopyWith<_$_ThemeList> get copyWith =>
      throw _privateConstructorUsedError;
}
