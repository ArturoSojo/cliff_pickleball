import 'package:json_annotation/json_annotation.dart';

part 'auth_device_request.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AuthDeviceRequest {
  String fingerprint;
  String? name;
  String type;
  String? customId;
  Map<String, String>? features;

  AuthDeviceRequest(
      this.fingerprint, this.name, this.type, this.customId, this.features);

  AuthDeviceRequest.check(this.fingerprint, this.type, {this.features});

  factory AuthDeviceRequest.fromJson(Map<String, dynamic> json) =>
      _$AuthDeviceRequestFromJson(json);

  /// Connect the generated [_$AuthDeviceRequestToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$AuthDeviceRequestToJson(this);
}
