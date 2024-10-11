import 'package:injectable/injectable.dart';
import '../utils/Color_Model.dart';

@injectable
class ProfileThemeSelector {
  static const String chinchinTheme = "chinchin-theme";
  static const String defaultTheme = "default";

  String selectTheme({ColorModel? profile}) {
    print("select theme ${profile?.name} ${profile?.idDoc}");
    return profile?.name ?? defaultTheme;
  }
}
