import 'dart:ffi';

import 'package:injectable/injectable.dart';
import 'package:cliff_pickleball/domain/access_token_response.dart';
import 'package:cliff_pickleball/domain/credential_response.dart';
import 'package:cliff_pickleball/pages/login/get_credentials.dart';
import 'package:cliff_pickleball/utils/utils.dart';

import '../../services/cacheService.dart';
import '../../services/http/domain/role_request.dart';
import '../../services/http/result.dart';
import '../../styles/theme_selector.dart';

@injectable
class LoginService {
  final Cache _cache;
  final GetCredentials _getCredentials;
  final ThemeSelector _themeSelector;

  LoginService(this._cache, this._getCredentials, this._themeSelector);

  Future<Result<Void>> passwordGrant(String email, String password) async {
    return _getCredentials
        .passwordGrant(email, password)
        .then((value) => MyUtils.nextResult(value, _authDevice));
  }

  Future<Result<AccessTokenResponse>> refreshToken(
      String accessToken, String refreshToken) {
    return _getCredentials
        .refreshToken(accessToken, refreshToken)
        .then((value) => MyUtils.nextResult(value, _saveAccessToken));
  }

  Future<Result<AccessTokenResponse>> _saveAccessToken(
      Result<AccessTokenResponse> result) async {
    var accessTokenResponse = result.obj;
    if (accessTokenResponse != null) {
      await _cache.saveAccessToken(accessTokenResponse);
      /*var expiresIn = accessTokenResponse.expiresIn;
      var ttl = Optional.ofNullable(expiresIn)
          .map((p0) => Duration(seconds: p0 - 10))
          .orElse(const Duration(minutes: 1));

      if (accessTokenResponse.refreshToken != null && expiresIn != null) {
        accessTokenResponse.expireDate =
            DateTime.now().add(Duration(seconds: expiresIn - 10));

        await _cache.saveAccessTokenResponse(
            accessTokenResponse, const Duration(days: 365));
      } else {
        await _cache.saveAccessTokenResponse(accessTokenResponse, ttl);
      }

      await _cache.saveAccessTokenResponse(
          accessTokenResponse, const Duration(days: 365));*/

      return result;
    }

    return Result.result(result);
  }

  Future<Result<Void>> _authDevice(Result<AccessTokenResponse> result) async {
    await _saveAccessToken(result);
    var accessToken = result.obj?.accessToken;
    if (accessToken != null) {
      return _getCredentials.authDevice(accessToken).then(Result.result);
    }

    return Result.failMsg("No hay access token para el dispositivo");
  }

  Future<Result<Void>> login(String email, String password) {
    return _getCredentials.credentials(email, password).then((result) {
      return MyUtils.nextResult(result, (result) {
        return auth(result.obj).then((value) => Result.result(value));
      });
    });
  }

  Future<Result<AccessTokenResponse>> auth(
      CredentialResponse? credentialResponse) {
    var clientId = credentialResponse?.integration?.client?.id;
    var clientSecret = credentialResponse?.integration?.secret?.id;

    if (credentialResponse != null &&
        clientId != null &&
        clientSecret != null) {
      print(credentialResponse);
      _cache.setCacheJson("credentials", credentialResponse);
      return authorize(clientId, clientSecret);
    }

    return Future.value(Result.failMsg("Este usuario no posee integración"));
  }

  Future<Result<AccessTokenResponse>> authorize(
      String clientId, String secret) {
    return _getCredentials.authorize(clientId, secret).then((result) {
      if (result.success) {
        var accessTokenResponse = result.obj;

        var expiresIn = accessTokenResponse?.expiresIn ?? 180;

        if (accessTokenResponse != null) {
          _cache.setCacheJson("access_token", accessTokenResponse);
        }
      }

      return result;
    });
  }

  Future<Result<Void>> saveProfile() {
    return _getCredentials.profile().then((value) {
      if (value.success) {
        var profile = value.obj;
        if (profile != null) {
          _cache.saveDeviceIsAuthorized(profile.id!);
          _themeSelector.selectThemeFromProfile(profile);
          return _cache.saveProfile(profile).then((v) => Result.result(value));
        }
      }
      return Result.result(value);
    });
  }

  Future<void> saveRoles(roles) {
    return _cache.saveRoles(roles);
  }

  Future<Result<Void>> getRole(String roleName) {
    return _getCredentials.role().then((value) {
      if (value.success) {
        var role = value.obj; // ?
        if (role != null) {
          var roles = role.roles ?? [];
          if (roles.length != 0) {
            /* for (var element in roles) {
              print(element.toJson());
            } */
            var result = roleName == "servicepay"
                ? roles
                    .firstWhere((Role role) => role.appName == "SERVICEPAY_POS")
                : roles.firstWhere((Role role) => role.appName == "POS");
            if (result.businessId != null) {
              return saveInitData(result.businessId ?? "", roleName);
            }
          }
        }
      }
      return Result.result(value);
    });
  }

  Future<Result<Void>> saveInitData(String businessId, String role) {
    return _getCredentials.init(businessId, role).then((value) {
      //print("VALUE RNOW: $value");
      if (value.success) {
        var initData = value.obj;
        print(value.obj?.inventory?[0].balance);
        if (initData != null) {
          if (initData.profile?.id != null) {
            _cache.saveDeviceIsAuthorized(initData.profile?.id ?? "");
          }
          return _cache
              .saveInitData(initData, role)
              .then((v) => Result.result(value));
        }
      }
      return Result.result(value);
    });
  }
}
