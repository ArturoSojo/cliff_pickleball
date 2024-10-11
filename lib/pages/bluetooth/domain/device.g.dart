// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_DeviceBluetooth _$$_DeviceBluetoothFromJson(Map<String, dynamic> json) =>
    _$_DeviceBluetooth(
      name: json['name'] as String,
      macAddress: json['mac_address'] as String,
      id: json['id'] as String?,
      p: json['p'] as int?,
    );

Map<String, dynamic> _$$_DeviceBluetoothToJson(_$_DeviceBluetooth instance) {
  final val = <String, dynamic>{
    'name': instance.name,
    'mac_address': instance.macAddress,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('p', instance.p);
  return val;
}
