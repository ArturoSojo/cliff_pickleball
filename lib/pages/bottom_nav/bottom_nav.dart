import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:cliff_pickleball/utils/staticNamesRoutes.dart';

import '../../widgets/tabs.dart';
import 'bottom_nav_bloc.dart';

class BottomNavScreen extends StatefulWidget {
  final BottomNavBloc bloc;

  const BottomNavScreen({Key? key, required this.child, required this.bloc})
      : super(key: key);
  final Widget child;

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen>
    with WidgetsBindingObserver {
  AppLifecycleState? _lastLifecycleState;
  final _logger = Logger();

  List<ScaffoldWithNavBarTabItem> tabs = [
    ScaffoldWithNavBarTabItem(
        initialLocation: StaticNames.homeName.path,
        icon: const Icon(Icons.home_filled),
        label: "Inicio"),
    ScaffoldWithNavBarTabItem(
        initialLocation: StaticNames.bluetoothName.path,
        icon: const Icon(Icons.bluetooth),
        label: "Conectar"),
    ScaffoldWithNavBarTabItem(
        initialLocation: StaticNames.store.path,
        icon: const Icon(Icons.store),
        label: "Inventario"),
    ScaffoldWithNavBarTabItem(
        initialLocation: StaticNames.logoutName.path,
        icon: const Icon(Icons.exit_to_app),
        label: "Cerrar sesión"),
  ];

  List<NavigationDestinationTabItem> destinations = [
    NavigationDestinationTabItem(
      initialLocation: StaticNames.homeName.path,
      selectedIcon: const Icon(Icons.home_filled),
      icon: const Icon(Icons.home_filled),
      label: "Inicio",
    ),
    NavigationDestinationTabItem(
      initialLocation: StaticNames.bluetoothName.path,
      selectedIcon: const Icon(Icons.bluetooth),
      icon: const Icon(Icons.bluetooth),
      label: "Conectar",
    ),
    NavigationDestinationTabItem(
      initialLocation: StaticNames.store.path,
      selectedIcon: const Icon(Icons.store),
      icon: const Icon(Icons.store),
      label: "Inventario",
    ),
    NavigationDestinationTabItem(
      initialLocation: StaticNames.logoutName.path,
      selectedIcon: const Icon(Icons.exit_to_app),
      icon: const Icon(Icons.exit_to_app),
      label: "Cerrar sesión",
    ),
  ];

  int get _currentIndex => _locationToTabIndex(GoRouter.of(context).location);

  int _locationToTabIndex(String location) {
    final index =
        tabs.indexWhere((t) => location.startsWith(t.initialLocation));
    // if index not found (-1), return 0
    return index < 0 ? 0 : index;
  }

  // callback used to navigate to the desired tab
  void _onItemTapped(BuildContext context, int tabIndex) {
    // go to the initial location of the selected tab (by index)
    print(tabs[tabIndex].initialLocation);
    if (tabIndex != _currentIndex) {
      context.go(tabs[tabIndex].initialLocation);
    } else {
      if (tabs[tabIndex].initialLocation == "/home") {
        context.goNamed(StaticNames.homeName.name);
      }
    }
  }

  void _onDestinationTapped(BuildContext context, int tabIndex) {
    // go to the initial location of the selected tab (by index)
    print(destinations[tabIndex].initialLocation);
    if (tabIndex != _currentIndex) {
      context.go(destinations[tabIndex].initialLocation);
    } else {
      if (destinations[tabIndex].initialLocation == "/home") {
        context.goNamed(StaticNames.homeName.name);
      }
    }
  }

  BottomNavBloc _bloc() {
    return widget.bloc;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bloc().init();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _logger.i("$state");
    _lastLifecycleState = state;

    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _disconnectDevice();
        break;
    }
  }

  void _disconnectDevice() {
    _bloc().disconnectDevice();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BottomNavBloc, BottomNavState>(
      bloc: _bloc(),
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (true) {
          return Scaffold(
              resizeToAvoidBottomInset: false,
              body: widget.child,
              bottomNavigationBar: NavigationBar(
                onDestinationSelected: (index) =>
                    _onDestinationTapped(context, index),
                selectedIndex: _currentIndex,
                destinations: destinations,
              ));
        }
      },
    );
  }
}
