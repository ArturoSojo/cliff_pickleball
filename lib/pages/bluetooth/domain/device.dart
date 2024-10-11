import 'package:freezed_annotation/freezed_annotation.dart';

part 'device.freezed.dart';
part 'device.g.dart';

@freezed
class DeviceBluetooth with _$DeviceBluetooth {
  @JsonSerializable(
      explicitToJson: true,
      fieldRename: FieldRename.snake,
      includeIfNull: false)
  const factory DeviceBluetooth({
    required String name,
    required String macAddress,
    String? id,
    int? p,
  }) = _DeviceBluetooth;

  factory DeviceBluetooth.fromJson(Map<String, Object?> json) =>
      _$DeviceBluetoothFromJson(json);
}

/*
class DeviceBluetooth {
  String? name;
  String? macAddress;
  String? id;
  int? p;

  DeviceBluetooth({this.name, this.macAddress, this.p, this.id});


  toJson(){
    Map<String, dynamic> data = {};
    data["name"] = name;
    data["macAddress"] = macAddress;
    data["p"] = p;
    data["id"] = id;
    return data;
  }
  DeviceBluetooth.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    macAddress = json["macAddress"];
    p = json["p"];
    id = json["id"];
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceBluetooth &&
          runtimeType == other.runtimeType &&
          macAddress == other.macAddress;

  @override
  int get hashCode => macAddress.hashCode;
}
*/
