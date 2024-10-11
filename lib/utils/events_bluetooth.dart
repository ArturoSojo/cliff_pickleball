event(method, function) {
  switch (method) {
    case 'onRequestWaitingUser':
      return function(method);
    case 'onWaitingforData':
      break;
    case 'onRequestDevice':
      break;
    case 'onRequestDisplay':
      return function(method);
    case 'onQposInfoResult':
      return function(method);
    case 'onCbcMacResult':
      break;
    case 'onRequestTime':
      return function(method);
    case 'onRequestSetPin':
      return function(method);
    case 'onDeviceFound':
      return function(method);
    // for (int i = 0; i < items.length; i++) {
    //   buffer.write(items[i]);
    // }
    // print("onDeviceFound : ${buffer.toString()}");
    case 'onQposDoTradeLog':
      break;
    case 'onQposKsnResult':
      break;

    case 'onQposIdResult':
      return function(method);
    case 'onError':
      return function(method);
    case 'onReturnRSAResult':
      break;
    case 'onQposDoSetRsaPublicKey':
      break;
    case 'onGetShutDownTime':
      break;
    case 'writeMifareULData':
      return function(method);
    case 'onReturnGetPinResult':
      break;
    case 'onReturniccCashBack':
      break;
    case 'onReturnSetSleepTimeResult':
      break;
    case 'onEmvICCExceptionData':
      break;
    case 'onGetInputAmountResult':
      break;
    case 'onRequestQposDisconnected':
      return function(method)(method);
    case 'onReturnPowerOnIccResult':
      break;
    case 'onBluetoothBondTimeout':
      break;
    case 'onBluetoothBonded':
      break;
    case 'onReturnPowerOnNFCResult':
      break;
    case 'onConfirmAmountResult':
      break;
    case 'onQposIsCardExist':
      break;
    case 'onSearchMifareCardResult':
      return function(method);
    case 'onRequestQposConnected':
      return function(method);
    case 'onRequestDeviceScanFinished':
      return function(method);
      return function(method);
    default:
      throw ArgumentError('error');
  }
}
