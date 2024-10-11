import 'package:json_annotation/json_annotation.dart';

part 'result_close.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ResultClose {
  bool success;
  String? message;
  String? lot;
  String? terminal;
  String? amountBuy;
  String? countBuy;
  String? amountAnulate;
  String? countAnulate;
  String? cardType;
  String? affiliation;
  String? status;

  ResultClose(
      this.success,
      this.message,
      this.lot,
      this.terminal,
      this.amountBuy,
      this.countBuy,
      this.amountAnulate,
      this.countAnulate,
      this.cardType,
      this.affiliation,
      this.status);

  factory ResultClose.fromJson(Map<String, dynamic> json) =>
      _$ResultCloseFromJson(json);

  Map<String, dynamic> toJson() => _$ResultCloseToJson(this);

  static List<ResultClose> fromJsonList(List list) {
    return list.map((json) => ResultClose.fromJson(json)).toList();
  }
}
