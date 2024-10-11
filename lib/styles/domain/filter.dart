import 'package:freezed_annotation/freezed_annotation.dart';

part 'filter.freezed.dart';
part 'filter.g.dart';

@freezed
class Filter with _$Filter {
  @JsonSerializable(
      explicitToJson: true,
      fieldRename: FieldRename.snake,
      includeIfNull: false)
  const factory Filter({
    required Set<String> idDocs,
  }) = _Filter;

  factory Filter.fromJson(Map<String, Object?> json) => _$FilterFromJson(json);
}
