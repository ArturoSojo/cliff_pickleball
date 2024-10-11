import 'package:flutter/widgets.dart';

class PathAndName {
  String name;
  String path;

  PathAndName({required this.name, required this.path});

  RouteWidget pathWidget() {
    return RouteWidget(path);
  }
}

class Path {
  String path;

  Path(this.path);
}

class RouteWidget extends Widget {
  final String route;

  const RouteWidget(this.route, {super.key});

  @override
  Element createElement() {
    // TODO: implement createElement
    throw UnimplementedError();
  }
}
