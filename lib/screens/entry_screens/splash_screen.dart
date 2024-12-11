import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cliff_pickleball/config/colors_collection.dart';
import 'package:cliff_pickleball/config/images_path_collection.dart';
import 'package:cliff_pickleball/config/text_collection.dart';
import 'package:cliff_pickleball/config/text_style_collection.dart';
import 'package:cliff_pickleball/providers/incoming_data_provider.dart';
import 'package:cliff_pickleball/providers/theme_provider.dart';
import 'package:cliff_pickleball/screens/entry_screens/intro_screen.dart';
import 'package:cliff_pickleball/screens/main_screens/main_screen_management.dart';
import 'package:cliff_pickleball/services/device_specific_operations.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:cliff_pickleball/services/navigation_management.dart';
import 'package:provider/provider.dart';
//import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import 'package:cliff_pickleball/config/stored_string_collection.dart';
import 'package:cliff_pickleball/services/debugging.dart';
import 'package:cliff_pickleball/services/local_data_management.dart';
import 'package:cliff_pickleball/config/types.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late StreamSubscription _intentDataStreamSubscription;
  String? _sharedText;

  _incomingDataManagement() {
    /// For sharing images coming from outside the app while the app is in the memory
    /*  _intentDataStreamSubscription = ReceiveSharingIntent.instance
        .getMediaStream()
        .listen((List<SharedMediaFile>? value) {
      debugShow("Shared MediaStream: $value");
      if (value != null && mounted) {
        final _data = [];

        for (var element in value) {
          _data.add(
              {"path": element.path, "type": _getIncomingMediaType(element)});
        }

        Provider.of<IncomingDataProvider>(context, listen: false)
            .setIncomingData(_data);
      }
    }, onError: (err) {
      debugShow("getIntentDataStream error: $err");
    });*/

    /// For sharing images coming from outside the app while the app is closed
/*    ReceiveSharingIntent.instance
        .getInitialMedia()
        .then((List<SharedMediaFile>? value) {
      debugShow("Shared Images: $value");
      if (value != null && mounted) {
        final _data = [];

        for (var element in value) {
          _data.add(
              {"path": element.path, "type": _getIncomingMediaType(element)});
        }

        Provider.of<IncomingDataProvider>(context, listen: false)
            .setIncomingData(_data);
      }
    });*/
  }

  _initialize() async {
    await Provider.of<ThemeProvider>(context, listen: false).initialization();
    _incomingDataManagement();
    _switchToNextScreen();
  }

  @override
  void initState() {
    _initialize();
    makeScreenCleanView();
    makeScreenStrictPortrait();

    super.initState();
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 2.0;

    return Scaffold(
      backgroundColor: AppColors.splashScreenColor,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                AppImages.mainSplashScreenLogo,
                width: MediaQuery.of(context).size.width / 2.3,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Center(
              child: Text(
                AppText.appName,
                style: TextStyleCollection.headingTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _switchToNextScreen() async {
    final _currAccData =
        await DataManagement.getStringData(StoredString.accCreatedBefore);

    Timer(
        const Duration(milliseconds: 500),
        () => Navigation.intentStraight(context,
            _currAccData == null ? const IntroScreens() : const MainScreen()));
  }
}
/*
_getIncomingMediaType(SharedMediaFile element) {
  if (element.type == SharedMediaType.file) {
    return IncomingMediaType.file.toString();
  }
  if (element.type == SharedMediaType.image) {
    return IncomingMediaType.image.toString();
  }
  if (element.type == SharedMediaType.video) {
    return IncomingMediaType.video.toString();
  }
}*/
