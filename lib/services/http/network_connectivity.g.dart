// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_connectivity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetworkState _$NetworkStateFromJson(Map<String, dynamic> json) => NetworkState(
      $enumDecode(_$ConnectivityResultEnumMap, json['result']),
      json['is_online'] as bool,
    );

Map<String, dynamic> _$NetworkStateToJson(NetworkState instance) =>
    <String, dynamic>{
      'result': _$ConnectivityResultEnumMap[instance.result]!,
      'is_online': instance.isOnline,
    };

const _$ConnectivityResultEnumMap = {
  ConnectivityResult.bluetooth: 'bluetooth',
  ConnectivityResult.wifi: 'wifi',
  ConnectivityResult.ethernet: 'ethernet',
  ConnectivityResult.mobile: 'mobile',
  ConnectivityResult.none: 'none',
  ConnectivityResult.vpn: 'vpn',
  ConnectivityResult.other: 'other',
};
