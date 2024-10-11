import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plugin_qpos/QPOSModel.dart';
import 'package:flutter_plugin_qpos/flutter_plugin_qpos.dart';

import '../styles/bg.dart';
import '../widgets/LogUtil.dart';
import '../widgets/Utils.dart';

class Plugin extends StatefulWidget {
  const Plugin({super.key});

  @override
  _Plugin createState() => _Plugin();
}

final communicationMode = const [
  'AUDIO',
  'BLUETOOTH_VER2',
  'UART',
  'UART_K7',
  'BLUETOOTH_2Mode',
  'USB',
  'BLUETOOTH_4Mode',
  'UART_GOOD',
  'USB_OTG',
  'USB_OTG_CDC_ACM',
  'BLUETOOTH',
  'BLUETOOTH_BLE',
  'UNKNOW',
];

class _Plugin extends State<Plugin> {
  final FlutterPluginQpos _flutterPluginQpos = FlutterPluginQpos();
  String _platformVersion = 'Unknown';
  String display = "";
  String tlvData = "";
  QPOSModel? trasactionData;
  StreamSubscription? _subscription;
  List<String>? items;

  // var items = List<String>?;
  int? numPinField;
  var scanFinish = 0;
  String? _mAddress;
  var _updateValue;
  bool _visibility = true;
  bool concelFlag = false;
  int? test;
  bool offstage = true;
  final _mifareBlockAddrTxt = TextEditingController();
  final _mifareValueTxt = TextEditingController();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _subscription =
        _flutterPluginQpos.onPosListenerCalled!.listen((QPOSModel datas) {
      parasListener(datas);
      setState(() {
        trasactionData = datas;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    //取消监听
    if (_subscription != null) {
      _subscription!.cancel();
    }
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    if (!mounted) return;

    setState(() {
      _platformVersion = _flutterPluginQpos.posSdkVersion.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget buttonSection = Row(
      children: [
        ElevatedButton(
          onPressed: () async {
            setState(() {
              scanFinish = -1;
              items = null;
            });
            selectDevice();
          },
          child: const Text("select device"),
        ),
        ElevatedButton(
          onPressed: () async {
            startDoTrade();
          },
          child: const Text("start do trade"),
        ),
        ElevatedButton(
          onPressed: () async {
            disconnectToDevice();
          },
          child: const Text("disconnect"),
        )
      ],
    );

    PopupMenuButton popMenuUpdate() {
      return PopupMenuButton<String>(
          initialValue: "",
          child: const Text("update button"),
          onSelected: (String string) {
            print("selected:$string");
            onUpdateButtonSelected(string, context);
          },
          itemBuilder: (context) => <PopupMenuItem<String>>[
                const PopupMenuItem(
                  value: "0",
                  child: Text("update Emv Config By bin"),
                ),
                const PopupMenuItem(
                  value: "1",
                  child: Text("update Firmware"),
                ),
                const PopupMenuItem(
                  value: "2",
                  child: Text("update IPEK"),
                ),
                const PopupMenuItem(
                  value: "3",
                  child: Text("update Master Key"),
                ),
                const PopupMenuItem(
                  value: "4",
                  child: Text("update Session Key"),
                ),
                const PopupMenuItem(
                  value: "5",
                  child: Text("update Emv Config By xml"),
                )
              ]);
    }

    PopupMenuButton popMenuInfo() {
      return PopupMenuButton<String>(
          initialValue: "",
          child: //RaisedButton(
              //onPressed: () {  },
              const Text("device_info button"),
          onSelected: (String string) {
            print(string.toString());
            onDeviceInfoButtonSelected(string, context);
          },
          itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                const PopupMenuItem(
                  value: "0",
                  child: Text("get Device Id"),
                ),
                const PopupMenuItem(
                  value: "1",
                  child: Text("get Device Info"),
                ),
                const PopupMenuItem(
                  value: "2",
                  child: Text("get Device update Key CheckValue"),
                ),
                const PopupMenuItem(
                  value: "3",
                  child: Text("get Device Key CheckValue"),
                ),
                const PopupMenuItem(
                  value: "4",
                  child: Text("reset Pos"),
                )
              ]);
    }

    PopupMenuButton popMenuOperateMifare() {
      return PopupMenuButton<String>(
          initialValue: "",
          child: //RaisedButton(
              //onPressed: () {  },
              const Text("MenuOperateMifare"),
          onSelected: (String string) {
            print(string.toString());
            onOperateMifareButtonSelected(string, context);
          },
          itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                const PopupMenuItem(
                  value: "0",
                  child: Text("ADD"),
                ),
                const PopupMenuItem(
                  value: "1",
                  child: Text("REDUCE"),
                ),
                const PopupMenuItem(
                  value: "2",
                  child: Text("RESTORE"),
                ),
              ]);
    }

    _showMenu(int type) {
      final RenderBox? button = context.findRenderObject() as RenderBox?;
      final RenderBox? overlay =
          Overlay.of(context).context.findRenderObject() as RenderBox?;
      final RelativeRect position = RelativeRect.fromRect(
        Rect.fromPoints(
          button!.localToGlobal(const Offset(0, 0), ancestor: overlay),
          button.localToGlobal(button.size.bottomRight(Offset.zero),
              ancestor: overlay),
        ),
        Offset.zero & overlay!.size,
      );
      var pop;
      if (type == 1)
        pop = popMenuUpdate();
      else if (type == 2)
        pop = popMenuInfo();
      else if (type == 3) pop = popMenuOperateMifare();
      showMenu<String>(
        context: context,
        items: pop.itemBuilder(context) as List<PopupMenuEntry<String>>,
        position: position,
      ).then<void>((String? newValue) {
        if (!mounted) return null;
        if (newValue == null) {
          if (pop.onCanceled != null) pop.onCanceled!();
          return null;
        }
        if (pop.onSelected != null) pop.onSelected!(newValue);
      });
    }

    Widget textSection = Column(
      children: [
        Text(
          _platformVersion,
        ),
//          Text(
//            '$display',
//          ),
        Text(
          '$trasactionData',
        ),
      ],
    );

    Widget mifareSection = Offstage(
      offstage: offstage,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        _flutterPluginQpos.pollOnMifareCard(10);
                      },
                      child: const Text('pollOnMifare'))),
              Expanded(
                  child: ElevatedButton(
                onPressed: () {
                  //MifareCardOperationType should be "CLASSIC" or "UlTRALIGHT"
                  //keyType should be "Key A" or "Key B"
                  var blockAddress = _mifareBlockAddrTxt.text;
                  print("address:$blockAddress");
                  if (blockAddress.isEmpty) blockAddress = "0A";
                  _flutterPluginQpos.authenticateMifareCard(
                      "CLASSIC", "Key A", blockAddress, "ffffffffffff", 20);
                },
                child: const Text('authenticateMifare'),
              )),
              Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        // _flutterPluginQpos.operateMifareCardData("CLASSIC", "Key A", "0A", "ffffffffffff", 20);
                        _showMenu(3);
                      },
                      child: const Text('operateMifareData')))
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        var blockAddress = _mifareBlockAddrTxt.text;
                        print("address:$blockAddress");
                        if (blockAddress.isEmpty) blockAddress = "0A";
                        _flutterPluginQpos.readMifareCard(
                            "CLASSIC", blockAddress, 20);
                      },
                      child: const Text('readMifare'))),
              Expanded(
                  child: ElevatedButton(
                onPressed: () {
                  var blockAddress = _mifareBlockAddrTxt.text;
                  var value = _mifareValueTxt.text;
                  print("address:$blockAddress value:$value");
                  if (blockAddress.isEmpty) blockAddress = "0A";
                  if (value.isEmpty) value = "0002";
                  _flutterPluginQpos.setIsOperateMifare(
                      false); //set false so the int value won't be conver to Hex
                  _flutterPluginQpos.writeMifareCard(
                      "CLASSIC", blockAddress, value, 20);
                },
                child: const Text('writeMifare'),
              )),
              Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        _flutterPluginQpos.finishMifareCard(10);
                      },
                      child: const Text('finishMifare')))
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: TextField(
                controller: _mifareBlockAddrTxt,
                //把 TextEditingController 对象应用到 TextField 上
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  labelText: 'mifare block address',
                  border: OutlineInputBorder(),
                ),
              )),
              Expanded(
                  child: TextField(
                controller: _mifareValueTxt,
                //把 TextEditingController 对象应用到 TextField 上
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  labelText: 'write or operate value',
                  border: OutlineInputBorder(),
                ),
              )),
            ],
          )
        ],
      ),
    );

    Widget textResultSection = Column(
      children: [
        Text(
          display,
        ),
      ],
    );

    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('plugin page'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(2.0),
            children: [
              ElevatedButton(
                onPressed: () async {
                  openUart();
                },
                child: const Text("open uart"),
              ),
              buttonSection,
              textSection,
              ElevatedButton(
                  onPressed: () {
                    _showMenu(1);
                  },
                  child: const Text("update button")),
              // btnMenuSection(),
              // btnMenuDeviceInfoSection,
              ElevatedButton(
                  onPressed: () {
                    _showMenu(2);
                  },
                  child: const Text("device info button")),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      offstage = !offstage;
                    });
                  },
                  child: const Text("operate mifare")),

              getListSection() ?? const Text(''),
              textResultSection,
              mifareSection,

//              getupdateSection()
            ],
          )),
    );
  }

//
//  Future requestPermission(List<PermissionGroup> permissions) async {
//    if(permissions == null || permissions.length<1){
//      return false;
//    }
//    // 申请权限
//    Map<PermissionGroup, PermissionStatus> permissionsMap =
//        await PermissionHandler().requestPermissions(permissions);
//    PermissionStatus permission = null;
//    // 申请结果
//    for (int i = 0; i < permissions.length; i++) {
//      permission = await PermissionHandler()
//          .checkPermissionStatus(permissions[i]);
//      if (permission != PermissionStatus.granted) {
//        Fluttertoast.showToast(msg: "denied");
//        return false;
//      }
//      return true;
//    }
//  }

  void searchNearByDevice() {}

//conectar dispositivo bluetooth
  Future<void> connectToDevice(String item) async {
    List<String> addrs = item.split("//");
    _mAddress = addrs[1];
    setState(() {
      scanFinish = 0;
      items = null;
    });
    await _flutterPluginQpos.connectBluetoothDevice(addrs[1]);
  }

  Future<void> disconnectToDevice() async {
    await _flutterPluginQpos.disconnectBT();
  }

  startDoTrade() {
    try {
      int keyIndex = 0;
      // params['keyIndex'] = 0;
      _flutterPluginQpos.setFormatId(FormatID.DUKPT);
      // _flutterPluginQpos.setCardTradeMode(CardTradeMode.SWIPE_TAP_INSERT_CARD);
      // _flutterPluginQpos.setDoTradeMode(DoTradeMode.COMMON);
      _flutterPluginQpos.doTrade(keyIndex);
    } catch (err) {}
  }

  void parasListener(QPOSModel datas) {
    //Map map =  Map<String, dynamic>.from(json.decode(datas));
    // CustomerModel testModel = CustomerModel.fromJson(json.decode(datas));
    //String method = map["method"];
    String? method = datas.method;
    List<String> paras = List.empty();
    //String parameters = map["parameters"];
    String? parameters = datas.parameters;
    if (parameters != null && parameters.isNotEmpty) {
      paras = parameters.split("||");
    }

    switch (method) {
      case 'onRequestTransactionResult':
        setState(() {
          display = "onRequestTransactionResult: ${parameters!}\n$display\n$tlvData";
        });
        break;
      case 'onRequestWaitingUser':
        setState(() {
          display = "Please insert/swipe/tap card";
        });
        break;
      case 'onReturnConverEncryptedBlockFormat':
        break;
      case 'onWaitingforData':
        break;
      case 'onRequestDevice':
        break;
      case 'onEncryptData':
        break;
      case 'onRequestDisplay':
        setState(() {
          display = parameters!;
        });
        break;
      case 'onQposInfoResult':
        setState(() {
          display = parameters!;
        });
        break;
      case 'onCbcMacResult':
        break;
      case 'onRequestTime':
        _flutterPluginQpos.sendTime("20200215175558");
        break;
      case 'onAddKey':
        break;
      case 'onTradeCancelled':
        break;
      case 'onRequestSetPin':
        setState(() {
          display = "Please input pin on your app";
        });
        _flutterPluginQpos.sendPin("1111");
        break;
      case 'onQposRequestPinResult':
        _showKeyboard(context, parameters!);
        break;
      case 'onGetPosComm':
        break;
      case 'onDeviceFound':
        setState(() {
          items ??= List.empty(growable: true);
          items!.add(parameters!);
        });
        StringBuffer buffer = StringBuffer();
        for (int i = 0; i < items!.length; i++) {
          buffer.write(items![i]);
        }
        print("onDeviceFound : ${buffer.toString()}");
        break;
      case 'onQposDoTradeLog':
        break;
      case 'onQposKsnResult':
        break;
      case 'onDoTradeResult':
        if (Utils.equals(paras[0], "ICC")) {
          _flutterPluginQpos.doEmvApp("START");
        }

        if (Utils.equals(paras[0], "NFC_ONLINE") ||
            Utils.equals(paras[0], "NFC_OFFLINE")) {
          Future map =
              _flutterPluginQpos.getNFCBatchData().then((value) => setState(() {
                    display = value.toString();
                  }));
        } else if (Utils.equals(paras[0], "MCR")) {
          setState(() {
            display = paras[1];
          });
        }
        break;
      case 'onQposIdResult':
        setState(() {
          display = parameters!;
        });
        break;
      case 'onError':
        setState(() {
          display = parameters!;
        });
        break;
      case 'onReturnRSAResult':
        break;
      case 'onQposDoSetRsaPublicKey':
        break;
      case 'onGetShutDownTime':
        break;
      case 'writeMifareULData':
        setState(() {
          display = "writeMifareULData:${parameters!}";
        });
        break;
      case 'onQposGenerateSessionKeysResult':
        break;
      case 'verifyMifareULData':
        break;
      case 'transferMifareData':
        break;
      case 'onGetSleepModeTime':
        break;
      case 'onRequestNoQposDetectedUnbond':
        break;
      case 'onRequestBatchData':
        // print("onRequestBatchData:" + parameters!);

        break;
      case 'onReturnGetPinResult':
        break;
      case 'onReturniccCashBack':
        break;
      case 'onReturnSetSleepTimeResult':
        break;
      case 'onPinKey_TDES_Result':
        break;
      case 'onEmvICCExceptionData':
        break;
      case 'onGetInputAmountResult':
        break;
      case 'onRequestQposDisconnected':
        setState(() {
          display = "device disconnected!";
        });
        break;
      case 'onReturnPowerOnIccResult':
        break;
      case 'onBluetoothBondTimeout':
        break;
      case 'onBluetoothBonded':
        break;
      case 'onReturnDownloadRsaPublicKey':
        break;
      case 'onReturnPowerOnNFCResult':
        break;
      case 'onConfirmAmountResult':
        break;
      case 'onQposIsCardExist':
        break;
      case 'onSearchMifareCardResult':
        setState(() {
          display = parameters!;
        });
        break;
      case 'onReturnBatchSendAPDUResult':
        break;
      case 'onReturnApduResult':
        break;
      case 'onBatchReadMifareCardResult':
        break;
      case 'onSetBuzzerTimeResult':
        break;
      case 'onWriteBusinessCardResult':
        break;
      case 'onBatchWriteMifareCardResult':
        break;
      case 'onSetBuzzerResult':
        break;
      case 'onRequestSelectEmvApp':
        _flutterPluginQpos.selectEmvApp(1);
        break;
      case 'onLcdShowCustomDisplay':
        break;
      case 'onRequestQposConnected':
        setState(() {
          display = "device connected!";
          // Navigator.push(context, MaterialPageRoute(builder: (context)=>SecondPage(_flutterPluginQpos)));
        });
        break;
      case 'onUpdatePosFirmwareResult':
        concelFlag = true;

        break;
      case 'onUpdatePosFirmwareProcessChanged':
        print('onUpdatePosFirmwareProcessChanged$parameters');

        print('onUpdatePosFirmwareProcessChanged${double.parse(parameters!)}');

        break;

      case 'onReturnPowerOffNFCResult':
        break;
      case 'onReadBusinessCardResult':
        break;
      case 'onReturnPowerOffIccResult':
        break;
      case 'onSetBuzzerStatusResult':
        break;
      case 'onRequestTransactionLog':
        break;
      case 'onGetBuzzerStatusResult':
        break;
      case 'onSetManagementKey':
        break;
      case 'onUpdateMasterKeyResult':
        break;
      case 'onReturnUpdateIPEKResult':
        break;
      case 'onBluetoothBonding':
        break;
      case 'onSetParamsResult':
        break;
      case 'onReturnSetMasterKeyResult':
        break;
      case 'onReturnNFCApduResult':
        break;
      case 'onReturnCustomConfigResult':
        break;
      case 'onRequestUpdateWorkKeyResult':
        break;
      case 'onReturnUpdateEMVRIDResult':
        break;
      case 'onReturnReversalData':
        break;
      case 'onReturnUpdateEMVResult':
        break;
      case 'onBluetoothBoardStateResult':
        break;
      case 'onGetCardNoResult':
        break;
      case 'onRequestCalculateMac':
        break;
      case 'onRequestFinalConfirm':
        break;
      case 'onSetSleepModeTime':
        break;
      case 'onRequestSetAmount':
        Map<String, String> params = Map<String, String>();

        simpleDialog(context).then((value) {
          setState(() {
            print("final type:" + value);
            params['transactionType'] = value;
            params['amount'] = "100";
            params['cashbackAmount'] = "";
            params['currencyCode'] = "156";
            // params['transactionType'] = "GOODS";
            _flutterPluginQpos.setAmount(params);
          });
        });

        break;
      case 'onReturnGetEMVListResult':
        break;
      case 'onRequestDeviceScanFinished':
        setState(() {
          scanFinish = 1;
        });
        break;
      case 'onRequestSignatureResult':
        break;
      case 'onRequestIsServerConnected':
        break;
      case 'onRequestNoQposDetected':
        break;
      case 'onRequestOnlineProcess':
        tlvData = parameters!;
        Future map = _flutterPluginQpos
            .anlysEmvIccData(parameters)
            .then((value) => setState(() {
                  //print("anlysEmvIccData:"+value.toString());
                  LogUtil.v("anlysEmvIccData:$value");
                  // An example to show how to get the key value
                  var tlvData = value["tlv"];
                  if (tlvData != null) print("tlv= " + tlvData);
                  String str = "8A023030"; //Currently the default value,
                  _flutterPluginQpos
                      .sendOnlineProcessResult(str); //脚本通知/55域/ICCDATA
                }));

        break;
      case 'onBluetoothBondFailed':
        break;
      case 'onWriteMifareCardResult':
        setState(() {
          display = parameters!;
        });
        break;
      case 'onQposIsCardExistInOnlineProcess':
        break;
      case 'onSetPosBlePinCode':
        break;
      case 'onQposDoGetTradeLogNum':
        break;
      case 'onGetDevicePubKey':
        break;
      case 'onReturnGetQuickEmvResult':
        break;
      case 'onReturnSignature':
        break;
      case 'onReadMifareCardResult':
        setState(() {
          display = parameters!;
        });
        break;
      case 'onOperateMifareCardResult':
        setState(() {
          display = parameters!;
        });
        break;
      case 'getMifareFastReadData':
        break;
      case 'getMifareReadData':
        setState(() {
          display = parameters!;
        });
        break;
      case 'getMifareCardVersion':
        break;
      case 'onFinishMifareCardResult':
        setState(() {
          display = parameters!;
        });
        break;
      case 'onQposDoGetTradeLog':
        break;
      case 'onRequestUpdateKey':
        break;
      case 'onReturnSetAESResult':
        break;
      case 'onReturnAESTransmissonKeyResult':
        break;
      case 'onVerifyMifareCardResult':
        setState(() {
          display = parameters!;
        });
        break;
      case 'onGetKeyCheckValue':
        break;
      case 'bluetoothIsPowerOff2Mode':
        break;
      case 'bluetoothIsPowerOn2Mode':
        break;
      case 'onReturnGetPinInputResult':
        setState(() {
          numPinField = int.parse(parameters!);
        });
        break;
      default:
        throw ArgumentError('error');
    }
  }

  void selectDevice() {
    // _flutterPluginQpos.requestPermission(communicationMode[10]);
    _flutterPluginQpos.init(communicationMode[10]);
    _flutterPluginQpos.scanQPos2Mode(10);
  }

  void openUart() {
    _flutterPluginQpos.init(communicationMode[2]);
    _flutterPluginQpos.openUart("/dev/ttyS1");
  }

  Widget _getListDate(BuildContext context, int position) {
    if (items != null) {
      return TextButton(
          onPressed: () => connectToDevice(items![position]),
          child: Text("text ${items![position]}"));
    } else {
      return TextButton(
          onPressed: () => connectToDevice(items![position]),
          child: const Text("No item"));
    }
  }

  Widget? getListSection() {
    if (items == null) {
      if (scanFinish == 0) {
        return const Text("");
      } else {
        if (scanFinish == -1) {
          return const Center(
              child: CircularProgressIndicator(
            color: ColorUtil.primary,
          ));
        }
      }
    } else {
      if (scanFinish == 1) {
        Widget listSection = ListView.builder(
          shrinkWrap: true,
          //解决无限高度问题
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(5.0),
          itemExtent: 50.0,
          itemCount: items == null ? 0 : items!.length,
          itemBuilder: (BuildContext context, int index) {
            return _getListDate(context, index);
          },
        );
        return listSection;
      } else {
        return const Center(
            child: CircularProgressIndicator(
          color: ColorUtil.primary,
        ));
      }
    }
  }

  Widget getupdateSection() {
    if (_visibility) {
      return LinearProgressIndicator(
        backgroundColor: Colors.blue,
        value: _updateValue,
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
      );
    } else {
      return const Text("");
    }
  }

  operatUpdateProcess(ByteData value, BuildContext context) async {
    // await pr!.show();
    Uint8List list = value.buffer.asUint8List(0);
    var upContent = Utils.Uint8ListToHexStr(list);
    print("upContent:$upContent");
    await _flutterPluginQpos.updatePosFirmware(upContent!, _mAddress!);
  }

  void updatePos(BuildContext context) async {
    DefaultAssetBundle.of(context).load('configs/upgrader.asc').then((value) {
      setState(() {
        _visibility = true;
      });

      operatUpdateProcess(value, context);

      print("点击事件结束");
    });
  }

  void onUpdateButtonSelected(String string, BuildContext context) {
    print("update button:$string");
    switch (string) {
      case "0":
        Future<ByteData> future =
            DefaultAssetBundle.of(context).load('configs/emv_capk.bin');
        DefaultAssetBundle.of(context)
            .load('configs/emv_app.bin')
            .then((value) {
          Uint8List list = value.buffer.asUint8List(0);
          var emvapp = Utils.Uint8ListToHexStr(list);
          print("emvConfig:$emvapp");
          future.then((onValue) {
            Uint8List list = onValue.buffer.asUint8List(0);
            var emvcapk = Utils.Uint8ListToHexStr(list);
            print("emvConfig:$emvcapk");
            _flutterPluginQpos.updateEmvConfig(emvapp!, emvcapk!);
          });
        });
        break;
      case "1":
        updatePos(context);
        break;
      case "2":
        _flutterPluginQpos.doUpdateIPEKOperation(
            0,
            "09118012400705E00000",
            "C22766F7379DD38AA5E1DA8C6AFA75AC",
            "B2DE27F60A443944",
            "09118012400705E00000",
            "C22766F7379DD38AA5E1DA8C6AFA75AC",
            "B2DE27F60A443944",
            "09118012400705E00000",
            "C22766F7379DD38AA5E1DA8C6AFA75AC",
            "B2DE27F60A443944");

        break;
      case "3":
        _flutterPluginQpos.setMasterKey(
            "1A4D672DCA6CB3351FD1B02B237AF9AE", "08D7B4FB629D0885", 0);

        break;
      case "4":
        _flutterPluginQpos.updateWorkKey(
            "1A4D672DCA6CB3351FD1B02B237AF9AE",
            "08D7B4FB629D0885",
            "1A4D672DCA6CB3351FD1B02B237AF9AE",
            "08D7B4FB629D0885",
            "1A4D672DCA6CB3351FD1B02B237AF9AE",
            "08D7B4FB629D0885",
            0);
        break;
      case "5":
        DefaultAssetBundle.of(context)
            .loadString('configs/emv_profile_tlv.xml', cache: false)
            .then((value) {
          print("emvConfig:$value");
          _flutterPluginQpos.updateEMVConfigByXml(value);
        });
        break;
    }
  }

  void onDeviceInfoButtonSelected(String string, BuildContext context) {
    switch (string) {
      case "0":
        _flutterPluginQpos.getQposId();

        // _flutterPluginQpos.setBuzzerStatus(0);
        // _flutterPluginQpos.doSetBuzzerOperation(3);
        // _flutterPluginQpos.setShutDownTime(20);
        // _flutterPluginQpos.setSleepModeTime(10);

        break;
      case "1":
        _flutterPluginQpos.getQposInfo();
        //an example to get track2 without doTrade
        // its callback is onRequestBatchData
        // the return data's format is length+data
        // var currentTime = "20211123143010"; //must be yyyyMMddHHmmss
        // _flutterPluginQpos.getTrack2Ciphertext(currentTime);
        break;
      case "2":
        _flutterPluginQpos.getUpdateCheckValue();

        break;
      case "3":
        _flutterPluginQpos.getKeyCheckValue(0, 'DUKPT_MKSK_ALLTYPE');

        break;
      case "4":
        _flutterPluginQpos.resetQPosStatus().then((value) => setState(() {
              if (value!) {
                setState(() {
                  display = "pos reset";
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>SecondPage(_flutterPluginQpos)));
                });
              }
            }));
      // bool a = _flutterPluginQpos.resetPosStatus() as bool;
      // if(a) {
      // }
    }
  }

  void onOperateMifareButtonSelected(String string, BuildContext context) {
    var mifareCardOperationType = "ADD";
    switch (string) {
      case "0":
        mifareCardOperationType = "ADD";
        break;
      case "1":
        mifareCardOperationType = "REDUCE";
        break;
      case "2":
        mifareCardOperationType = "RESTORE";
        break;
      default:
        break;
    }
    var blockAddress = _mifareBlockAddrTxt.text;
    var value = _mifareValueTxt.text;
    print("operate address:$blockAddress value:$value");
    if (blockAddress.isEmpty) blockAddress = "0A";
    if (value.isEmpty) value = "01";
    _flutterPluginQpos.operateMifareCardData(
        mifareCardOperationType, blockAddress, value, 20);
  }

  void _showKeyboard(BuildContext context, String parameters) {
    print("_showKeyboard:$parameters");

    List<String> keyBoardList = List.empty(growable: true);
    var paras = parameters.split("||");
    String keyMap = paras[0];

    for (int i = 0; i < keyMap.length; i += 2) {
      String keyValue = keyMap.substring(i, i + 2);
      print("POS$keyValue");
      keyBoardList.add(int.parse(keyValue, radix: 16).toString());
    }

    for (int i = 0; i < keyBoardList.length; i++) {
      if (keyBoardList[i] == "13") {
        keyBoardList[i] = "cancel";
      } else if (keyBoardList[i] == "14") {
        keyBoardList[i] = "del";
      } else if (keyBoardList[i] == "15") {
        keyBoardList[i] = "confirm";
      }
    }
  }
}

Future simpleDialog(BuildContext context) async {
  print("simpleDialog");
  var result = await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text("Transcation Type"),
          children: <Widget>[
            SimpleDialogOption(
              child: const Text("GOODS"),
              onPressed: () {
                print("GOODS");
                Navigator.pop(context, "GOODS");
              },
            ),
            SimpleDialogOption(
              child: const Text("SERVICES "),
              onPressed: () {
                print("SERVICES");
                Navigator.pop(context, "SERVICES");
              },
            ),
            SimpleDialogOption(
              child: const Text("CASH"),
              onPressed: () {
                print("CASH");
                Navigator.pop(context, "CASH");
              },
            ),
            SimpleDialogOption(
              child: const Text("CASHBACK"),
              onPressed: () {
                print("CASHBACK");
                Navigator.pop(context, "CASHBACK");
              },
            ),
            SimpleDialogOption(
              child: const Text("INQUIRY"),
              onPressed: () {
                print("INQUIRY");
                Navigator.pop(context, "INQUIRY");
              },
            ),
            SimpleDialogOption(
              child: const Text("TRANSFER"),
              onPressed: () {
                print("TRANSFER");
                Navigator.pop(context, "TRANSFER");
              },
            ),
            SimpleDialogOption(
              child: const Text("ADMIN"),
              onPressed: () {
                print("ADMIN");
                Navigator.pop(context, "ADMIN");
              },
            ),
            SimpleDialogOption(
              child: const Text("CASHDEPOSIT"),
              onPressed: () {
                print("CASHDEPOSIT");
                Navigator.pop(context, "CASHDEPOSIT");
              },
            ),
            SimpleDialogOption(
              child: const Text("PAYMENT"),
              onPressed: () {
                print("PAYMENT");
                Navigator.pop(context, "PAYMENT");
              },
            ),
            SimpleDialogOption(
              child: const Text("PBOCLOG||ECQ_INQUIRE_LOG"),
              onPressed: () {
                print("PBOCLOG||ECQ_INQUIRE_LOG");
                Navigator.pop(context, "PBOCLOG||ECQ_INQUIRE_LOG");
              },
            ),
            SimpleDialogOption(
              child: const Text("SALE"),
              onPressed: () {
                print("SALE");
                Navigator.pop(context, "SALE");
              },
            ),
            SimpleDialogOption(
              child: const Text("PREAUTH"),
              onPressed: () {
                print("PREAUTH");
                Navigator.pop(context, "PREAUTH");
              },
            ),
            SimpleDialogOption(
              child: const Text("ECQ_DESIGNATED_LOAD"),
              onPressed: () {
                print("ECQ_DESIGNATED_LOAD");
                Navigator.pop(context, "ECQ_DESIGNATED_LOAD");
              },
            ),
            SimpleDialogOption(
              child: const Text("ECQ_UNDESIGNATED_LOAD"),
              onPressed: () {
                print("ECQ_UNDESIGNATED_LOAD");
                Navigator.pop(context, "ECQ_UNDESIGNATED_LOAD");
              },
            ),
            SimpleDialogOption(
              child: const Text("ECQ_CASH_LOAD"),
              onPressed: () {
                print("ECQ_CASH_LOAD");
                Navigator.pop(context, "ECQ_CASH_LOAD");
              },
            ),
            SimpleDialogOption(
              child: const Text("ECQ_CASH_LOAD_VOID"),
              onPressed: () {
                print("ECQ_CASH_LOAD_VOID");
                Navigator.pop(context, "ECQ_CASH_LOAD_VOID");
              },
            ),
            SimpleDialogOption(
              child: const Text("CHANGE_PIN"),
              onPressed: () {
                print("CHANGE_PIN");
                Navigator.pop(context, "CHANGE_PIN");
              },
            ),
            SimpleDialogOption(
              child: const Text("REFOUND"),
              onPressed: () {
                print("REFOUND");
                Navigator.pop(context, "REFOUND");
              },
            ),
            SimpleDialogOption(
              child: const Text("SALES_NEW"),
              onPressed: () {
                print("SALES_NEW");
                Navigator.pop(context, "SALES_NEW");
              },
            ),
          ],
        );
      });
  print("result --- > " + result);
  return result;
}

// class SecondPage extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//       appBar: AppBar(title: Text('The second page'),),
//       body: Center(child: RaisedButton(
//         child: Text('Return'),
//         onPressed: (){
//           Navigator.pop(context);
//         },
//       ),),
//     );
//   }
//
// }
