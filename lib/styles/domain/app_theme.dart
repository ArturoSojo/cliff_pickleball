import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cliff_pickleball/styles/domain/app_assets.dart';
import 'package:cliff_pickleball/styles/domain/app_colors.dart';
import 'package:cliff_pickleball/styles/domain/filter.dart';

part 'app_theme.freezed.dart';
part 'app_theme.g.dart';

@freezed
class AppTheme with _$AppTheme {
  @JsonSerializable(
      explicitToJson: true,
      fieldRename: FieldRename.snake,
      includeIfNull: false)
  const factory AppTheme({
    required String name,
    @Default(false) bool dflt,
    required Filter filter,
    required AppColors colors,
    required AppAssets assetsImg,
  }) = _AppTheme;

  factory AppTheme.fromJson(Map<String, Object?> json) =>
      _$AppThemeFromJson(json);
}
