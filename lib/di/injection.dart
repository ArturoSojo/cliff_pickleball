import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:cliff_pickleball/di/injection.config.dart';

GetIt getIt = GetIt.instance;

@injectableInit
Future<void> configureInjection(String environment) async =>
    await getIt.init(environment: environment);

abstract class Env {
  static const demo = 'demo';
  static const qa = 'qa';
  static const prod = 'prod';
  static const dev = 'dev';
}
