import 'package:cliff_pickleball/config/text_collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cliff_pickleball/config/colors_collection.dart';
import 'package:cliff_pickleball/screens/social_media/components/life_cycle_event_handler.dart';
import 'package:cliff_pickleball/screens/social_media/landing/landing_page.dart';
import 'package:cliff_pickleball/screens/social_media/screens/mainscreen.dart';
import 'package:cliff_pickleball/screens/social_media/services/user_service.dart';
import 'package:cliff_pickleball/screens/social_media/utils/config.dart';
import 'package:cliff_pickleball/screens/social_media/utils/constants.dart';
import 'package:cliff_pickleball/screens/social_media//view_models/theme/theme_view_model.dart';
import 'package:cliff_pickleball/providers/providers_collection.dart';

mainSocial() async {
  await Config.initFirebase();
  runApp(SocialMedia());
}

class SocialMedia extends StatefulWidget {
  @override
  _SocialMediaState createState() => _SocialMediaState();
}

class _SocialMediaState extends State<SocialMedia> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(
        detachedCallBack: () => UserService().setUserStatus(false),
        resumeCallBack: () => UserService().setUserStatus(true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providersCollection,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppText.appName,
        theme: ThemeData(
            fontFamily: AppText.fontFamily,
            bottomSheetTheme: const BottomSheetThemeData(
                backgroundColor: AppColors.transparentColor)),
        builder: (context, child) => MediaQuery(
          child: child!,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: ((BuildContext context, snapshot) {
            if (snapshot.hasData) {
              return TabScreen();
            } else
              return Landing();
          }),
        ),
      ),
    );
  }

  ThemeData themeData(ThemeData theme) {
    return theme.copyWith(
      textTheme: GoogleFonts.nunitoTextTheme(
        theme.textTheme,
      ),
    );
  }
}
