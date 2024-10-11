import 'package:intl/intl.dart';

class DateUtil {
  static String qposDate() {
    var dateFormat = DateFormat("yyyyMMddhhmmss");
    var now = DateTime.now();
    return dateFormat.format(now);
  }
}
