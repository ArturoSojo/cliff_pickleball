import 'package:json_annotation/json_annotation.dart';
import 'package:cliff_pickleball/domain/profile.dart';

import 'integration.dart';

part 'credential_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CredentialResponse {
  Profile? profile;
  Integration? integration;

  CredentialResponse({this.profile, this.integration});

  factory CredentialResponse.fromJson(Map<String, dynamic> json) =>
      _$CredentialResponseFromJson(json);

  /// Connect the generated [_$CredentialResponseToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$CredentialResponseToJson(this);
}
