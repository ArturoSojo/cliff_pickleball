import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_colors.freezed.dart';
part 'app_colors.g.dart';

@freezed
class AppColors with _$AppColors {
  @JsonSerializable(
      explicitToJson: true,
      fieldRename: FieldRename.snake,
      includeIfNull: false)
  const factory AppColors({
    required String primary,
    required String primaryLight,
  }) = _AppColors;

  factory AppColors.fromJson(Map<String, Object?> json) => _$AppColorsFromJson(json);
}