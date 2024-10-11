import 'package:json_annotation/json_annotation.dart';
import 'package:cliff_pickleball/domain/device.dart';
import 'package:cliff_pickleball/domain/device_config.dart';

part 'merchant_device_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MerchantDeviceResponse {
  Device? device;
  DeviceConfig? config;

  MerchantDeviceResponse({this.device, this.config});

  factory MerchantDeviceResponse.fromJson(Map<String, dynamic> json) =>
      _$MerchantDeviceResponseFromJson(json);

  /// Connect the generated [_$MerchantDeviceResponseToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$MerchantDeviceResponseToJson(this);
}
