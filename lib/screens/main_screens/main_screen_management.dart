import 'package:cliff_pickleball/config/text_style_collection.dart';
import 'package:cliff_pickleball/screens/social_media/chats/recent_chats.dart';
import 'package:cliff_pickleball/screens/social_media/main.dart';
import 'package:cliff_pickleball/screens/social_media/pages/feeds.dart';
import 'package:cliff_pickleball/screens/social_media/pages/notification.dart';
import 'package:cliff_pickleball/screens/social_media/pages/profile.dart';
import 'package:cliff_pickleball/screens/social_media/pages/search.dart';
import 'package:cliff_pickleball/screens/social_media/screens/mainscreen.dart';
import 'package:cliff_pickleball/screens/social_media/utils/firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:cliff_pickleball/config/colors_collection.dart';
import 'package:cliff_pickleball/config/images_path_collection.dart';
import 'package:cliff_pickleball/db_operations/firestore_operations.dart';
import 'package:cliff_pickleball/providers/chat/messaging_provider.dart';
import 'package:cliff_pickleball/providers/main_screen_provider.dart';
import 'package:cliff_pickleball/screens/common/scroll_to_hide_widget.dart';
import 'package:cliff_pickleball/screens/main_screens/home_screen.dart';
import 'package:cliff_pickleball/screens/main_screens/settings_screen.dart';
import 'package:cliff_pickleball/services/download_operations.dart';
import 'package:cliff_pickleball/services/encryption_operations.dart';
import 'package:cliff_pickleball/services/local_database_services.dart';
import 'package:cliff_pickleball/services/system_file_management.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

import 'package:cliff_pickleball/config/countable_data_collection.dart';
import 'package:cliff_pickleball/config/data_collection.dart';
import 'package:cliff_pickleball/config/text_collection.dart';
import 'package:cliff_pickleball/config/types.dart';
import 'package:cliff_pickleball/providers/connection_collection_provider.dart';
import 'package:cliff_pickleball/providers/main_scrolling_provider.dart';
import 'package:cliff_pickleball/providers/status_collection_provider.dart';
import 'package:cliff_pickleball/providers/theme_provider.dart';

import 'package:cliff_pickleball/services/device_specific_operations.dart';
import 'package:cliff_pickleball/services/local_data_management.dart';
import 'connection_management/connection_management.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  var activeSlideIndex = 0;
  final DBOperations _dbOperations = DBOperations();
  final LocalStorage _localStorage = LocalStorage();

  @override
  void initState() {
    updateCliffPickleball(context);

    final onlineStatus =
        Provider.of<ChatBoxMessagingProvider>(context, listen: false)
            .getOnlineStatus();
    _dbOperations.updateActiveStatus(onlineStatus);
    _localStorage.storeDbInstance(context);

    WidgetsBinding.instance.addObserver(this);
    _dbOperations.getAvailableUsersData(context);
    Provider.of<ConnectionCollectionProvider>(context, listen: false)
        .fetchLocalConnectedUsers(context);
    Provider.of<StatusCollectionProvider>(context, listen: false).initialize();

    final isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkTheme();

    showStatusAndNavigationBar();
    makeStatusBarTransparent();
    changeContextTheme(isDarkMode);

    Workmanager().initialize(
        bgTaskTopLevel, // The top level function, aka callbackDispatcher
        isInDebugMode: false);

    Workmanager().registerPeriodicTask(
      BgTask.deleteOwnActivityData['taskId'] ?? "1",
      BgTask.deleteOwnActivityData['task'] ?? BgTask.deleteOwnActivity,
      initialDelay: Duration(
          seconds: int.parse(
              BgTask.deleteOwnActivityData['initialDelayInSec'] ?? '30')),
      frequency: Duration(
          minutes: int.parse(
              BgTask.deleteOwnActivityData['frequencyInMin'] ?? '15')),
    );

    Workmanager().registerPeriodicTask(
      BgTask.deleteConnectionActivities['taskId'] ?? "2",
      BgTask.deleteConnectionActivities['task'] ??
          BgTask.deleteConnectionsActivity,
      initialDelay: Duration(
          seconds: int.parse(
              BgTask.deleteConnectionActivities['initialDelayInSec'] ?? '30')),
      frequency: Duration(
          minutes: int.parse(
              BgTask.deleteConnectionActivities['frequencyInMin'] ?? '15')),
    );

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final onlineStatus =
          Provider.of<ChatBoxMessagingProvider>(context, listen: false)
              .getOnlineStatus();
      _dbOperations.updateActiveStatus(onlineStatus);
    } else {
      final latestStatus =
          Provider.of<ChatBoxMessagingProvider>(context, listen: false)
              .getLastSeenDateTime();
      _dbOperations.updateActiveStatus(latestStatus);
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkTheme();

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColors.getBgColor(isDarkMode),
        drawer: _sideNavBar(), // Asignación del Drawer
        appBar:
            _appBar(context, isDarkMode), // Uso de una función para el AppBar
        body: _currentScreenDetector(),
      ),
    );
  }

  AppBar _appBar(BuildContext context, bool isDarkMode) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.getChatBgColor(isDarkMode),
      automaticallyImplyLeading: false,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.menu,
              color: isDarkMode
                  ? AppColors.pureWhiteColor
                  : AppColors.lightTextColor),
          onPressed: () {
            Scaffold.of(context)
                .openDrawer(); // Abre el Drawer al presionar el ícono
          },
        ),
      ),
      title: Text(
        AppText.appName,
        style: TextStyleCollection.headingTextStyle.copyWith(
            fontSize: 20,
            color: isDarkMode
                ? AppColors.pureWhiteColor
                : AppColors.lightTextColor),
      ),
    );
  }

  Drawer _sideNavBar() {
    final ScrollController messageScreenScrollController =
        Provider.of<MainScrollingProvider>(context).getScrollController();

    final int currentBottomIconIndex =
        Provider.of<MainScreenNavigationProvider>(context).getUpdatedIndex();

    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkTheme();

    return Drawer(
      backgroundColor: AppColors.getBgColor(isDarkMode),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.getBgColor(isDarkMode),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Navigation', style: TextStyle(color: Colors.white)),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // Cierra el Drawer al presionar el ícono
                  },
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.message,
                color: _getColor(0, isDarkMode, currentBottomIconIndex)),
            title: Text('Messages',
                style: TextStyle(
                    color: _getColor(0, isDarkMode, currentBottomIconIndex))),
            onTap: () {
              Provider.of<MainScreenNavigationProvider>(context, listen: false)
                  .setUpdatedIndex(0);
              Navigator.of(context)
                  .pop(); // Cierra el Drawer al presionar el ítem
            },
          ),
          ListTile(
            leading: Icon(Icons.connect_without_contact,
                color: _getColor(1, isDarkMode, currentBottomIconIndex)),
            title: Text('Connect',
                style: TextStyle(
                    color: _getColor(1, isDarkMode, currentBottomIconIndex))),
            onTap: () {
              Provider.of<MainScreenNavigationProvider>(context, listen: false)
                  .setUpdatedIndex(1);
              Navigator.of(context)
                  .pop(); // Cierra el Drawer al presionar el ítem
            },
          ),
          ListTile(
            leading: Icon(Icons.settings,
                color: _getColor(2, isDarkMode, currentBottomIconIndex)),
            title: Text('Settings',
                style: TextStyle(
                    color: _getColor(2, isDarkMode, currentBottomIconIndex))),
            onTap: () {
              Provider.of<MainScreenNavigationProvider>(context, listen: false)
                  .setUpdatedIndex(2);
              Navigator.of(context)
                  .pop(); // Cierra el Drawer al presionar el ítem
            },
          ),
          ListTile(
            leading: Icon(Icons.video_library,
                color: _getColor(3, isDarkMode, currentBottomIconIndex)),
            title: Text('Videos',
                style: TextStyle(
                    color: _getColor(3, isDarkMode, currentBottomIconIndex))),
            onTap: () {
              Provider.of<MainScreenNavigationProvider>(context, listen: false)
                  .setUpdatedIndex(3);
              Navigator.of(context)
                  .pop(); // Cierra el Drawer al presionar el ítem
            },
          ),
        ],
      ),
    );
  }

  Color _getColor(int index, bool isDarkMode, int currentBottomIconIndex) {
    return index == currentBottomIconIndex
        ? isDarkMode
            ? AppColors.darkBorderGreenColor
            : AppColors.lightBorderGreenColor
        : isDarkMode
            ? AppColors.darkInactiveIconColor
            : AppColors.lightInactiveIconColor;
  }

  _currentScreenDetector() {
    final currentIndex =
        Provider.of<MainScreenNavigationProvider>(context).getUpdatedIndex();

    switch (currentIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const ConnectionManagementScreen();
      case 2:
        return const SettingsScreen();
      case 3:
        return SocialMedia();
      case 4:
        return Chats();
    }
  }

  Future<bool> _onWillPop() async {
    final int currentBottomIconIndex =
        Provider.of<MainScreenNavigationProvider>(context, listen: false)
            .getUpdatedIndex();

    if (currentBottomIconIndex > 0) {
      Provider.of<MainScreenNavigationProvider>(context, listen: false)
          .setUpdatedIndex(0);

      return false;
    }

    Provider.of<ConnectionCollectionProvider>(context, listen: false)
        .destroyConnectedDataStream();
    //Provider.of<RequestConnectionsProvider>(context, listen: false).destroyReceivedRequestStream();

    return true;
  }
}

bgTaskTopLevel() {
  Workmanager().executeTask((taskName, inputData) async {
    switch (taskName) {
      case BgTask.deleteOwnActivity:
        await deleteOwnExpiredActivity(tableName: DbData.myActivityTable);
        break;
      case BgTask.deleteConnectionsActivity:
        await manageDeleteConnectionsExpiredActivity();
        break;
    }

    return true;
  });
}

deleteOwnExpiredActivity(
    {String tableName = DbData.myActivityTable, bool stop = false}) async {
  //try {

  final LocalStorage localStorage = LocalStorage();

  final activities = await localStorage.getAllActivity(
      tableName: tableName, withStoragePermission: false);

  final currDateTime = DateTime.now();

  //if (stop) return;

  for (final activity in activities) {
    await _deleteEligibleActivities(
        activity: activity,
        currDateTime: currDateTime,
        tableName: tableName,
        ownActivity: true);
  }
  // } catch (e) {
  //
  //   return [];
  // }
}

manageDeleteConnectionsExpiredActivity() async {
  final LocalStorage localStorage = LocalStorage();
  final connectionsData =
      await localStorage.getConnectionPrimaryData(withStoragePermission: false);

  if (connectionsData.isEmpty) return;

  Map<String, List<dynamic>> connData = {};

  for (final conn in connectionsData) {
    try {
      final activities = await localStorage.getAllActivity(
          tableName: DataManagement.generateTableNameForNewConnectionActivity(
              conn["id"]),
          withStoragePermission: false);
      connData[conn["id"]] = activities;
    } catch (e) {
      //
    }
  }

  final currDateTime = DateTime.now();

  for (final connId in connData.keys.toList()) {
    for (final activity in (connData[connId] ?? [])) {
      await _deleteEligibleActivities(
          activity: activity,
          currDateTime: currDateTime,
          tableName:
              DataManagement.generateTableNameForNewConnectionActivity(connId),
          ownActivity: false);
    }
  }
}

_deleteEligibleActivities(
    {required activity,
    required currDateTime,
    required String tableName,
    required bool ownActivity}) async {
  try {
    final date = Secure.decode(activity["date"]);
    final time = Secure.decode(activity["time"]);
    final LocalStorage localStorage = LocalStorage();

    DateFormat format = DateFormat("dd MMMM, yyyy hh:mm a");
    var formattedDateTime = format.parse('$date $time');
    final Duration diffDateTime = currDateTime.difference(formattedDateTime);

    if (diffDateTime.inHours >= TimeCollection.activitySustainTimeInHour) {
      if (ownActivity) {
        final done = await _ownActivityRemoteDataDeletion(activity: activity);
        if (!done) return;
      }

      if (Secure.decode(activity["type"]) !=
          ActivityContentType.text.toString()) {
        await SystemFileManagement.deleteFile(
            Secure.decode(activity['message']));
        if (Secure.decode(activity['type']) ==
            ActivityContentType.video.toString()) {
          final additionalDataString =
              Secure.decode(activity["additionalThings"]);

          final additionalData =
              DataManagement.fromJsonString(additionalDataString.toString());
          await SystemFileManagement.deleteFile(
              additionalData["thumbnail"] ?? '');
        }
      }

      await localStorage.deleteActivity(
          tableName: tableName,
          activityId: activity["id"],
          withStoragePermission: false);
    }
  } catch (e) {
    //
  }
}

Future<bool> _ownActivityRemoteDataDeletion({required activity}) async {
  final DBOperations dbOperations = DBOperations();

  final additionalThings = Secure.decode(activity["additionalThings"]);

  final remoteDataEncrypted =
      DataManagement.fromJsonString(additionalThings.toString())["remoteData"];
  final remoteDataDecrypted = Secure.decode(remoteDataEncrypted);

  await dbOperations.initializeFirebase();

  if (Secure.decode(activity["type"]) != ActivityContentType.text.toString()) {
    final data = await dbOperations.deleteMediaFromFirebaseStorage(
        DataManagement.fromJsonString(remoteDataDecrypted)['message']);

    if (!data) return data;
  }

  return await dbOperations.deleteParticularActivity(remoteDataEncrypted);
}
