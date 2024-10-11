import 'dart:async';
import 'dart:ffi';

import 'package:injectable/injectable.dart';
import 'package:cliff_pickleball/services/http/api_services.dart';
import 'package:cliff_pickleball/services/http/result.dart';
import 'package:cliff_pickleball/services/token_service.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class LogoutService {
  final ApiServices _apiServices;
  final TokenService _tokenService;

  LogoutService(this._apiServices, this._tokenService);

  Future<Result<Void>> closeSession() {
    return _tokenService.token().then((value) => value.obj).then(_close);
  }

  Future<Result<Void>> _close(String? accessToken) async {
    if (accessToken != null) {
      int retries = 0;
      return RetryWhenStream(
        () => Stream.fromFuture(_apiServices.closeSession(accessToken)),
        (e, s) {
          retries += 1;
          // if there is more than 5 retries, throw an error
          if (retries <= 5) return const Stream.empty();
          return Stream.error(e);
        },
      ).last;
      //return _apiServices.closeSession(accessToken);
    }

    return Result.success(null);
  }
}
