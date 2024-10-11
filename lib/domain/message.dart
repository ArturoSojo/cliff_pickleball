import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Message {
  int? code;
  String? message;
  List<String>? cause;

  Message({this.code, this.message, this.cause});

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  /// Connect the generated [_$MessageToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
