import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:cliff_pickleball/utils/utils.dart';
import 'package:uuid/uuid.dart';

@injectable
class FingerprintService {
  final _logger = Logger();
  static const key = "fingerprint";

  Future<String> fingerprint() {
    return MyUtils.prefs().then((prefs) {
      var fingerprint = prefs.getString(key);
      if (fingerprint == null) {
        fingerprint = const Uuid().v4();
        _logger.i("new fingerprint $fingerprint");
        prefs.setString(key, fingerprint);
      }

      return fingerprint;
    });
  }
}
