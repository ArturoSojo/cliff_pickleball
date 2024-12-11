import 'package:flutter/material.dart';
import 'package:cliff_pickleball/config/types.dart';
import 'package:cliff_pickleball/services/native_operations.dart';
import 'package:cliff_pickleball/services/toast_message_show.dart';

class NetworkManagementProvider extends ChangeNotifier {
  final NativeCallback _nativeCallback = NativeCallback();

  Future<bool> get isNetworkActive async =>
      await _nativeCallback.checkInternet();

  noNetworkMsg(BuildContext context,
          {bool showFromTop = true, bool? showCenterToast}) =>
      ToastMsg.showErrorToast('Network not available', context: context);
}
