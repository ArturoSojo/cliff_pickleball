import 'package:json_annotation/json_annotation.dart';

part 'auth_device_code_request.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AuthDeviceCodeRequest {
  String fingerprint;
  String authCode;
  String? name;

  AuthDeviceCodeRequest(this.fingerprint, this.authCode, this.name);

  factory AuthDeviceCodeRequest.fromJson(Map<String, dynamic> json) =>
      _$AuthDeviceCodeRequestFromJson(json);

  /// Connect the generated [_$AuthDeviceCodeRequestToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$AuthDeviceCodeRequestToJson(this);
}
