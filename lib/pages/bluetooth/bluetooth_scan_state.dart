part of 'bluetooth_scan_bloc.dart';

@immutable
abstract class BluetoothScanState {
  const BluetoothScanState();
}

class BluetoothScanInitial extends BluetoothScanState {
  const BluetoothScanInitial();
}

class BluetoothDeviceScanningState extends BluetoothScanState {
  final Set<DeviceBluetooth> devices;
  final bool scanFinished;

  const BluetoothDeviceScanningState(this.devices, this.scanFinished);
}

class BluetoothDeviceOnDeviceQposIdState extends BluetoothScanState {
  final DeviceBluetooth device;

  const BluetoothDeviceOnDeviceQposIdState(this.device);
}

class BluetoothDeviceConnectingState extends BluetoothScanState {
  final DeviceBluetooth device;

  const BluetoothDeviceConnectingState(this.device);
}

class BluetoothDeviceConnectedState extends BluetoothScanState {
  final DeviceBluetooth device;
  final Result<String>? result;

  const BluetoothDeviceConnectedState(this.device, {this.result});
}

class StartBluetoothSelectCommunicationModeState extends BluetoothScanState {
  final CommunicationMode mode;

  const StartBluetoothSelectCommunicationModeState(this.mode);
}

class ErrorState extends BluetoothScanState {
  final DeviceBluetooth? device;
  final String error;

  const ErrorState(this.device, this.error);
}
