import 'package:injectable/injectable.dart';
import 'package:cliff_pickleball/services/http/http_service.dart';
import 'package:cliff_pickleball/services/http/service_module.dart';
import 'package:cliff_pickleball/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class InjectionModule {
  @lazySingleton
  HttpService get httpService => ServiceModule.httpService();

  /*@preResolve
  Future<SharedPreferences> get prefs => MyUtils.prefs();*/
}
