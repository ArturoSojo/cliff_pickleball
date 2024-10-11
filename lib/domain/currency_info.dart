import 'package:json_annotation/json_annotation.dart';

part 'currency_info.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CurrencyInfo {
  String? code;
  String? name;
  String? isoNumber;
  int? decimals;
  String? symbol;
  String? ccrOperationSymbol;

  CurrencyInfo(
      {this.code,
      this.name,
      this.isoNumber,
      this.decimals,
      this.symbol,
      this.ccrOperationSymbol});

  factory CurrencyInfo.fromJson(Map<String, dynamic> json) =>
      _$CurrencyInfoFromJson(json);

  /// Connect the generated [_$CurrencyInfoToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$CurrencyInfoToJson(this);
}
