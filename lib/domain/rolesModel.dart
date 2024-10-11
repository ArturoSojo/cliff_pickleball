// ignore_for_file: file_names
import 'package:json_annotation/json_annotation.dart';

part 'rolesModel.g.dart';

@JsonSerializable()
class RolesModel {
  final bool servicepay;
  final bool pinpagos;

  RolesModel(this.pinpagos, this.servicepay);

  factory RolesModel.fromJson(Map<String, dynamic> json) => _$RolesModelFromJson(json);

  Map<String, dynamic> toJson() => _$RolesModelToJson(this);
}