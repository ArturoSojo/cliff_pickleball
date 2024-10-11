import 'package:flutter/material.dart';
import 'package:cliff_pickleball/pages/bluetooth/bluetooth_scan_bloc.dart';
import 'package:cliff_pickleball/styles/decorations_style.dart';
import 'package:cliff_pickleball/utils/translate.dart';

import '../../styles/bg.dart';
import '../../styles/text.dart';

class SelectBleMode extends StatefulWidget {
  final CommunicationMode mode;
  final BluetoothScanBloc bloc;

  const SelectBleMode(
    this.mode,
    this.bloc, {
    super.key,
  });

  @override
  SelectBleModeState createState() => SelectBleModeState();
}

class SelectBleModeState extends State<SelectBleMode> {
  List<CommunicationMode> staticData = CommunicationMode.values;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: (() => widget.bloc
                .add(BluetoothScanBleModeSelectedEvent(widget.mode))),
            icon: const Icon(Icons.arrow_back_sharp)),
        title: const Text('Seleccione tipo de comunicación',
            style: TitleTextStyle(fontSize: 16)),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(height: 0),
        itemBuilder: (builder, index) {
          CommunicationMode data = staticData[index];

          return ListTile(
            horizontalTitleGap: 0,
            minVerticalPadding: 0,
            minLeadingWidth: 0,
            selectedTileColor: MyTheme.grayLight,
            selectedColor: MyTheme.grayLight,
            splashColor: ColorUtil.primaryLightColor(),
            onTap: () =>
                widget.bloc.add(BluetoothScanBleModeSelectedEvent(data)),
            title: Container(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
              child: Text(translate(data.name),
                  style: data == widget.mode
                      ? TitleTextStyle(
                          color: ColorUtil.primaryLightColor(),
                          fontSize: 16,
                          fontWeight: FontWeight.bold)
                      : const TitleTextStyle(fontSize: 16)),
            ),
            selected: data == widget.mode,
          );
        },
        itemCount: staticData.length,
      ),
    );
  }
}
