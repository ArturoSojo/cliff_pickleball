import 'package:json_annotation/json_annotation.dart';

part 'password_grant_request.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PasswordGrantRequest {
  String clientId;
  String username;
  String password;
  String fingerprint;

  PasswordGrantRequest(
      this.clientId, this.username, this.password, this.fingerprint);

  factory PasswordGrantRequest.fromJson(Map<String, dynamic> json) =>
      _$PasswordGrantRequestFromJson(json);

  /// Connect the generated [_$PasswordGrantRequestToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$PasswordGrantRequestToJson(this);
}
