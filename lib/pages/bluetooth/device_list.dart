import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:cliff_pickleball/pages/bluetooth/bluetooth_scan_bloc.dart';
import 'package:cliff_pickleball/pages/bluetooth/device_tile.dart';
import 'package:cliff_pickleball/pages/bluetooth/domain/device.dart';

class DeviceList extends StatelessWidget {
  final _logger = Logger();
  final BluetoothScanBloc bloc;

  DeviceList({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BluetoothScanBloc, BluetoothScanState>(
        bloc: bloc,
        builder: (_, state) {
          Set<DeviceBluetooth> devices = (state is BluetoothDeviceScanningState)
              ? state.devices
              : <DeviceBluetooth>{};

          return LayoutBuilder(builder: (context, constraints) {
            return list(devices);
          });
        });
  }

  Widget list(Set<DeviceBluetooth> devices) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: devices.length,
        itemBuilder: (context, index) {
          return DeviceTile(devices.elementAt(index),
              (device) => bloc.add(BluetoothDeviceConnectEvent(device)));
        });
  }
}
