import 'package:json_annotation/json_annotation.dart';

part 'client.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Client {
  String? id;
  String? realm;
  String? name;
  String? ownerId;
  String? businessOwnerId;
  String? appIdentifier;
  String? createdBy;
  String? createdAt;

  Client(
      {this.id,
      this.realm,
      this.name,
      this.ownerId,
      this.businessOwnerId,
      this.appIdentifier,
      this.createdBy,
      this.createdAt});

  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);

  /// Connect the generated [_$ClientToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ClientToJson(this);
}
