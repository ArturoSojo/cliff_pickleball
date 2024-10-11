import 'package:injectable/injectable.dart';
import 'package:optional/optional.dart';
import 'package:cliff_pickleball/styles/theme_provider.dart';

import '../domain/initDataModel.dart';

@injectable
class ThemeSelector {
  final ThemeProvider _themeProvider;

  ThemeSelector(this._themeProvider);

  void selectThemeFromProfile(Profile profile) {
    var idDoc = profile.idDoc;
    if (idDoc != null) {
      //setThemeFromIdDoc(idDoc);
    }
  }

  void setThemeFromIdDoc(String idDoc) {
    var optional = _themeProvider.themes.values
        .where((appTheme) {
          return appTheme.filter.idDocs.contains(idDoc);
        })
        .map((e) => e.name)
        .firstOptional;

    optional.ifPresent(_themeProvider.changeTheme);
    if (optional.isEmpty) {
      _themeProvider.setDfltTheme();
    }
  }

  void setThemeFromDeviceJson(Map<String, dynamic> json) async {
    String? sellerIdDoc = json["device"]?["seller_id_doc"];
    if (sellerIdDoc != null) {
      setThemeFromIdDoc(sellerIdDoc);
    } else {
      _themeProvider.setDfltTheme();
    }
  }
}
