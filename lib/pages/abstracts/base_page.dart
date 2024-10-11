import 'package:cliff_pickleball/services/session_timer.dart';
import 'package:flutter/material.dart';

mixin BasicPage<Page extends BasePage> on BaseState<Page> {
  SessionTimer sessionTimer = SessionTimer();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: sessionTimer.userActivityDetected,
      onPanDown: sessionTimer.userActivityDetected,
      onScaleStart: sessionTimer.userActivityDetected,
      child: rootWidget(context),
    );
  }

  Widget rootWidget(BuildContext context);
}

abstract class BasePage extends StatefulWidget {
  BasePage({Key? key}) : super(key: key);
}

abstract class BaseState<Page extends BasePage> extends State<Page> {}
