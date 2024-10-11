import 'package:json_annotation/json_annotation.dart';

part 'secret.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Secret {
  String? clientId;
  String? id;
  String? createdBy;
  String? createdAt;

  Secret({this.clientId, this.id, this.createdBy, this.createdAt});

  factory Secret.fromJson(Map<String, dynamic> json) => _$SecretFromJson(json);

  Map<String, dynamic> toJson() => _$SecretToJson(this);
}
