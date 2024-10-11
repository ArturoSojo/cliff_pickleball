import 'package:json_annotation/json_annotation.dart';
import 'package:cliff_pickleball/domain/client.dart';
import 'package:cliff_pickleball/domain/secret.dart';

part 'integration.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Integration {
  Client? client;
  Secret? secret;

  Integration({this.client, this.secret});

  factory Integration.fromJson(Map<String, dynamic> json) =>
      _$IntegrationFromJson(json);

  Map<String, dynamic> toJson() => _$IntegrationToJson(this);
}
