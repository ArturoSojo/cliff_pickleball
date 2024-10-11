import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:page_transition/page_transition.dart';

import '../di/injection.dart';
import '../services/cacheService.dart';
import '../styles/bg.dart';
import '../utils/staticNamesRoutes.dart';

class SplashScreen extends StatelessWidget {
  final _logger = Logger();

  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var image = const Image(
      image: AssetImage("assets/img/Logo-PinPagos-02.png"),
      width: 200,
      height: 200,
    );
    return AnimatedSplashScreen.withScreenFunction(
      backgroundColor: ColorUtil.primaryColor(),
      splashIconSize: 300,
      duration: 1000,
      pageTransitionType: PageTransitionType.leftToRightWithFade,
      splash: image,
      animationDuration: const Duration(seconds: 1),
      screenFunction: () async {
        bool isLoggedIn = await getIt<Cache>().areCredentialsStored();
        _logger.i("tienes credenciales? $isLoggedIn");

        var location =
            isLoggedIn ? StaticNames.homeName.path : StaticNames.loginName.path;

        context.go(location);
        return image;

        /*return FutureBuilder(
            future: getIt<Cache>().areCredentialsStored(),
            builder: (context, snapshot) {

              var isLoggedIn = snapshot.data;
              if (isLoggedIn != null) {
                _logger.i("tienes credenciales? $isLoggedIn");
                var location =
                isLoggedIn ? StaticNames.homeName.path : StaticNames.loginName.path;

                context.go(location);
              }

              return image;
            });*/
      },
    );
  }
}
