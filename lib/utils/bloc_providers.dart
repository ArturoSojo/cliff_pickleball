import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cliff_pickleball/di/injection.dart';
import 'package:cliff_pickleball/pages/bluetooth/bluetooth_scan_bloc.dart';
import 'package:cliff_pickleball/pages/cancel_payment/cancel_payment_bloc.dart';
import 'package:cliff_pickleball/pages/login/login_bloc.dart';
import 'package:cliff_pickleball/pages/logout/logout_bloc.dart';
import 'package:cliff_pickleball/pages/new_sale/new_sale_bloc.dart';

import '../blocs/device_and_bluetooth/device_and_bluetooth_bloc.dart';

List<BlocProvider> blocProviders = [
  BlocProvider<BluetoothScanBloc>(
      create: (context) => getIt<BluetoothScanBloc>()),
  BlocProvider<NewSaleBloc>(create: (context) => getIt<NewSaleBloc>()),
  BlocProvider<LogoutBloc>(create: (context) => getIt<LogoutBloc>()),
  BlocProvider<LoginScreenBloc>(create: (context) => getIt<LoginScreenBloc>()),
  BlocProvider<DeviceAndBluetoothBloc>(
      create: (context) => getIt<DeviceAndBluetoothBloc>()),
  BlocProvider<CancelPaymentBloc>(
      create: (context) => getIt<CancelPaymentBloc>()),
  /* BlocProvider<LoginScreenBloc>(create: (context) => LoginScreenBloc()),
  BlocProvider<AuthDeviceBloc>(create: (context) => AuthDeviceBloc()),
  BlocProvider<LogoutBloc>(create: (context) => LogoutBloc()),
  BlocProvider<BluetoothScanBloc>(create: (context) => BluetoothScanBloc()),*/
];
