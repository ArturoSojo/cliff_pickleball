import 'package:json_annotation/json_annotation.dart';

part 'access_token_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccessTokenResponse {
  String? accessToken;
  int? expiresIn;
  String? tokenType;
  String? refreshToken;
  DateTime? expireDate;

  AccessTokenResponse(
      {this.accessToken,
      this.expiresIn,
      this.tokenType,
      this.refreshToken,
      this.expireDate});

  factory AccessTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$AccessTokenResponseFromJson(json);

  /// Connect the generated [_$AccessTokenResponseToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$AccessTokenResponseToJson(this);
}
