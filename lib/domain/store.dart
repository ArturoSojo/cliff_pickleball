import 'package:json_annotation/json_annotation.dart';

part 'store.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Store {
  String? id;
  String? name;
  String? address;
  Map<String, String>? phones;
  List<String>? emails;
  String? statusReason;
  String? status;

  Store(
      {this.id,
      this.name,
      this.address,
      this.phones,
      this.emails,
      this.statusReason,
      this.status});

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);

  /// Connect the generated [_$StoreToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$StoreToJson(this);
}
