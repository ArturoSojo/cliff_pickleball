part of 'bluetooth_scan_bloc.dart';

@immutable
abstract class BluetoothScanEvent {
  const BluetoothScanEvent();
}

class BluetoothScanInitEvent extends BluetoothScanEvent {
  const BluetoothScanInitEvent();
}

class StartBluetoothScanEvent extends BluetoothScanEvent {
  const StartBluetoothScanEvent();
}

class StartBluetoothSelectCommunicationModeEvent extends BluetoothScanEvent {
  const StartBluetoothSelectCommunicationModeEvent();
}

class BluetoothDeviceOnDeviceFoundEvent extends BluetoothScanEvent {
  const BluetoothDeviceOnDeviceFoundEvent();
}

class BluetoothDeviceScanFinishedEvent extends BluetoothScanEvent {
  const BluetoothDeviceScanFinishedEvent();
}



class BluetoothDeviceConnectEvent extends BluetoothScanEvent {
  final DeviceBluetooth device;
  const BluetoothDeviceConnectEvent(this.device);
}

class BluetoothDeviceConnectingEvent extends BluetoothScanEvent {
  const BluetoothDeviceConnectingEvent();
}

class BluetoothDeviceConnectedEvent extends BluetoothScanEvent {
  const BluetoothDeviceConnectedEvent();
}

class BluetoothDeviceDisconnectEvent extends BluetoothScanEvent {
  const BluetoothDeviceDisconnectEvent();
}

class BluetoothDeviceScanErrorEvent extends BluetoothScanEvent {
  final String error;

  const BluetoothDeviceScanErrorEvent(this.error);
}

class BluetoothScanBleModeSelectedEvent extends BluetoothScanEvent {
  final CommunicationMode mode;

  const BluetoothScanBleModeSelectedEvent(this.mode);
}
