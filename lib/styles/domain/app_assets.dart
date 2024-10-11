import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_assets.freezed.dart';
part 'app_assets.g.dart';

@freezed
class AppAssets with _$AppAssets {
  @JsonSerializable(
      explicitToJson: true,
      fieldRename: FieldRename.snake,
      includeIfNull: false)
  const factory AppAssets({
    required String uri,
    required String logo,
    required String logo2,
    required String logo3,
    required String closed,
    required String details,
    required String last,
    required String pos,
    required String report,
    required String sales,
    required String simple,
    required String test,
    required String transactions,
  }) = _AppAssets;

  factory AppAssets.fromJson(Map<String, Object?> json) => _$AppAssetsFromJson(json);
}