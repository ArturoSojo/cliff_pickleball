import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Profile {
  String? realm;
  String? id;
  String? emailDeflt;
  String? businessName;
  String? alias;
  String? country;
  bool? lock;
  String? idDoc;
  String? idDocType;
  String? type;

  Profile(
      {this.realm,
      this.id,
      this.emailDeflt,
      this.businessName,
      this.alias,
      this.country,
      this.lock,
      this.idDoc,
      this.idDocType,
      this.type});

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
