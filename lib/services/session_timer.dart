import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cliff_pickleball/di/injection.dart';
import 'package:cliff_pickleball/services/cacheService.dart';
import 'package:cliff_pickleball/services/http/result.dart';
import 'package:cliff_pickleball/utils/global.dart';
import 'package:cliff_pickleball/widgets/restart.dart';

import '../domain/access_token_response.dart';
import 'http/api_services.dart';

// import 'package:in_app_session_timeout/global.dart';
// import 'package:in_app_session_timeout/login_screen.dart';
// import 'package:in_app_session_timeout/main.dart';

class SessionTimer {
  int refresh = 30;
  bool _isLoading = false;
  int time2 = 10;
  int? time = 10;

  Timer timer = Timer(const Duration(seconds: 0), () {});

  // Timer refreshTime = Timer(Duration(seconds: 0), () { });

  final navigatorKey = Globalkeys.shellNavigatorKey;
  final Cache _cache = Cache();
  final _apiServices = getIt<ApiServices>();

  // Widget _circular = SizedBox(width: 25, height: 25 ,child: CircularProgressIndicator( color: ColorUtil.primary_light,));

  void startTimer() async {
    var res = await _cache.getAccessTokenResponse();
    // time = res!.expiresIn ?? 180;
    // print("inicio de timer ejecutado $time");
    // timer = Timer.periodic(Duration(seconds: time!), (_) {
    //   timedOut();
    // });
  }

  void userActivityDetected([_]) {
    if (timer != null || !timer.isActive) {
      timer.cancel();
      startTimer();
    }
    return;
  }

  // bool _isThereCurrentDialogShowing(BuildContext context) => ModalRoute.of(context)?.isCurrent != true;

  Future<void> timedOut() async {
    timer.cancel();
    await _refreshSession(navigatorKey.currentState!.overlay!.context);

    // refreshTime = Timer.periodic(new Duration(seconds: 1), (context) async {
    //   print(time2--);
    //   if(time2 == 0){
    //     if(refreshTime.isActive){
    //       refreshTime.cancel();
    //       // Navigator.pop(navigatorKey.currentState!.context);
    //     }
    //     await _removeSession(navigatorKey.currentState!.overlay!.context);
    //   }
    // });
    // await showDialog(
    //   context: navigatorKey.currentState!.overlay!.context,
    //   barrierDismissible: false,
    //   builder: (context)
    //     => Alerts.dialogTwoButtonActions(
    //       child: Text("Casi expira la sesión, ¿deseas retomarla?", style: subtitleStyleText("", 16)),
    //       actionButtonsNames:
    //         [
    //           "RETOMAR SESIÓN",
    //           "CERRAR SESIÓN"
    //         ],
    //       callback: () async => await _refreshSession(context),
    //       callbackTwo: () async => await _removeSession(context),
    //     ),
    // );
  }

  Future<void> _removeSession(BuildContext context) async {
    // if(refreshTime.isActive){
    //   refreshTime.cancel();
    // }
    if (timer.isActive) {
      timer.cancel();
    }
    _isLoading = true;
    // Navigator.pop(context);
    var tokenJson = await _cache.getCacheJson("access_token");
    print(tokenJson);
    var data = await _apiServices.closeSession(tokenJson["access_token"]);
    if (data.success) {
      await _cache.emptyCacheData();
      RestartWidget.restartApp(navigatorKey.currentState!.context);
    }
  }

  Future<void> removeTimers() async {
    print("luego de esperar 4 segundos ejecuto el removeTimers()");
    // Navigator.pop(navigatorKey.currentState!.context);
    // if(refreshTime.isActive){
    //   refreshTime.cancel();
    // }
    if (timer.isActive) {
      timer.cancel();
    }
  }

  Future<void> _refreshSession(BuildContext context) async {
    // if(refreshTime.isActive){
    //   refreshTime.cancel();
    // }
    time2 = 10;
    var data = await _cache.getAccessTokenResponse();
    if (data!.accessToken != null && data.refreshToken != null) {
      print(data.accessToken);
      var result = await _apiServices
          .refreshToken(data.accessToken!, data.refreshToken!)
          .onError((error, stacktrace) => Result.fail(error, stacktrace));
      if (result.success) {
        final AccessTokenResponse res = result.obj!;
        String access_token = res.accessToken ?? "";
        int expires_in = res.expiresIn ?? 0;
        if (access_token != "" && expires_in != 0) {
          _cache.saveAccessTokenResponse(res, Duration(seconds: expires_in));
          Navigator.pop(context);
          startTimer();
        } else {
          await _removeSession(context);
        }
      } else {
        await _removeSession(context);
      }
    } else {
      await _removeSession(context);
    }
  }
}
