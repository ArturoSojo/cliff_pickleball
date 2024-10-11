import 'package:flutter/material.dart';
import 'package:cliff_pickleball/pages/bluetooth/domain/device.dart';

import '../../di/injection.dart';
import '../../styles/bg.dart';
import '../../styles/color_provider/color_provider.dart';
import '../../styles/text.dart';
import '../../styles/theme_provider.dart';

class DeviceTile extends StatefulWidget {
  final DeviceBluetooth device;
  final Function(DeviceBluetooth) onTap;

  const DeviceTile(this.device, this.onTap, {super.key});

  @override
  State<DeviceTile> createState() => _DeviceTileState();
}

class _DeviceTileState extends State<DeviceTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onTap(widget.device),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: ColorUtil.lightGray,
                borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  device(widget.device),
                  Icon(
                    Icons.chevron_right,
                    color: ColorUtil.primaryLightColor(),
                  )
                ])),
      ),
    );
  }

  Widget device(DeviceBluetooth device) {
    return Row(children: [
      Icon(
        Icons.bluetooth,
        color: ColorUtil.primaryColor(),
        size: 25,
      ),
      const SizedBox(width: 15),
      Column(children: [
        device.name != "null"
            ? Text(device.name, style: titleStyleText("", 16))
            : const SizedBox(height: 4),
        Text(device.macAddress, style: titleStyleText("", 16))
      ]),
    ]);
  }
}
