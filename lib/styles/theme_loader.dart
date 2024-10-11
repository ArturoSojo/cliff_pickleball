import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:optional/optional.dart';
import 'package:cliff_pickleball/styles/domain/app_theme.dart';

import 'domain/theme_list.dart';

@injectable
class ThemeLoader {
  Future<List<AppTheme>> loadThemes() async {
    var path = "themes.json";

    var json = await rootBundle.loadString(path);

    var list = ThemeList.listFromJson(json);

    if (list.isEmpty) {
      throw Exception("themes are not set");
    }

    var dflt = list.where((element) => element.dflt).firstOptional;

    if (dflt.isEmpty) {
      throw Exception("default theme is null");
    }

    return list;
  }
}
