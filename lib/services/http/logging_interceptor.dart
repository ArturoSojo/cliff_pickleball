import 'package:http_interceptor/http_interceptor.dart';
import 'package:logger/logger.dart';

class LoggingInterceptor implements InterceptorContract {
  final _logger = Logger();

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    _logger.d(data.toString());
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    _logger.d(data.toString());
    return data;
  }
}
