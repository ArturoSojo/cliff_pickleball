import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'authorized_devices.freezed.dart';
part 'authorized_devices.g.dart';

@freezed
class AuthorizedDevices with _$AuthorizedDevices {
  @JsonSerializable(
      explicitToJson: true,
      fieldRename: FieldRename.snake,
      includeIfNull: false)
  const factory AuthorizedDevices({
    required Map<String, bool> map,
  }) = _AuthorizedDevices;

  factory AuthorizedDevices.fromJson(Map<String, Object?> json) => _$AuthorizedDevicesFromJson(json);
}