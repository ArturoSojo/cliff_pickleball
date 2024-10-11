import 'package:injectable/injectable.dart';
import 'package:cliff_pickleball/domain/credential_response.dart';
import 'package:cliff_pickleball/pages/login/login_service.dart';

import 'cacheService.dart';
import 'http/result.dart';

@injectable
class TokenService {
  final Cache _cache;
  final LoginService _loginService;

  TokenService(this._cache, this._loginService);

  Future<Result<String>> token() async {
    var accessTokenResponse = await _cache.getAccessTokenResponse();
    if (accessTokenResponse != null) {
      var accessToken = accessTokenResponse.accessToken;
      if (accessToken != null) {
        {
          var refreshToken = accessTokenResponse.refreshToken;
          var expireDate = accessTokenResponse.expireDate;
          if (refreshToken != null &&
              expireDate != null &&
              expireDate.isBefore(DateTime.now())) {
            return _loginService
                .refreshToken(accessToken, refreshToken)
                .then((value) {
              var token = value.obj?.accessToken;
              if (token != null) {
                return Result.success(token);
              }

              return Result.result(value);
            });
          }
        }

        return Future.value(Result.success(accessTokenResponse.accessToken));
      }
    }

    var credentialsJson = await _cache.getCacheJson("credentials");

    if (credentialsJson != null) {
      var credentialResponse = CredentialResponse.fromJson(credentialsJson);

      return _loginService.auth(credentialResponse).then((result) {
        if (result.success) {
          var accessToken = result.obj?.accessToken;
          if (accessToken != null) {
            return Result.success(accessToken);
          }

          return Result.failMsg("No hay access token");
        }

        return Result.result(result);
      });
    }

    return Future.value(
        Result.failMsg("No hay credenciales guardadas, inicie sesion"));
  }
}
