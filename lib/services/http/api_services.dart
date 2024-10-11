import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:cliff_pickleball/domain/initDataModel.dart';
import 'package:cliff_pickleball/domain/request/pin_pad_annul_request.dart';
import 'package:cliff_pickleball/domain/request/pin_pad_payment_request.dart';
import 'package:cliff_pickleball/services/http/domain/auth_device_request.dart';
import 'package:cliff_pickleball/services/http/domain/password_grant_request.dart';
import 'package:cliff_pickleball/services/http/http_util.dart';
import 'package:cliff_pickleball/services/http/init_headers.dart';
import 'package:cliff_pickleball/services/http/is_online_provider.dart';
import 'package:cliff_pickleball/services/http/result.dart';
import 'package:cliff_pickleball/utils/staticNamesServices.dart';
import 'package:cliff_pickleball/utils/testFormatted.dart';

import '../../domain/access_token_response.dart';
import '../../domain/credential_response.dart';
import '../../domain/message.dart';
import '../../pages/details/models/details_report_model.dart';
import '../../pages/product/screens/pospay/models/account_model.dart';
import '../../pages/product/screens/prepay/models/payment_model.dart';
import '../../pages/store/models/collect_channel_model.dart';
import '../../pages/store/models/rate_model.dart';
import '../../pages/store/models/store_model.dart';
import '../../utils/open_lote_formatted.dart';
import '../../utils/utils.dart';
import 'domain/auth_device_code_request.dart';
import 'domain/role_request.dart';
import 'http_service.dart';

@injectable
class ApiServices {
  final HttpService _httpService;
  final IsOnlineProvider _isOnlineProvider;

  ApiServices(this._httpService, this._isOnlineProvider);

  Uri url(String unencodedPath, {Map<String, String>? queryParameters}) {
    return Uri.https(MyUtils.base, unencodedPath, queryParameters);
  }

  Future<Result<T>> httpCall<T>(Future<Response> Function(Client client) f,
      {T Function(dynamic json)? parseJson}) async {
    var isOnline = await _isOnlineProvider.isOnline();

    if (isOnline) {
      return _httpService
          .response(f)
          .then((value) => HttpUtil.result(value, parseJson))
          .onError(HttpUtil.failResult);
    }

    return Future.value(Result.failMsg("No posee conexión a internet"));
  }

  Future<Result<AccessTokenResponse>> passwordGrant(
      PasswordGrantRequest request) {
    var uri = url(
        "${MyUtils.type}${MyUtils.authContextPath}${StaticNamesPath.passwordGrant.path}",
        queryParameters: {"grant_type": "password"});
    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
    };

    return httpCall(
        (client) =>
            client.post(uri, body: jsonEncode(request), headers: headers),
        parseJson: (json) => AccessTokenResponse.fromJson(json));
  }

  Future<Result<AccessTokenResponse>> refreshToken(
      String accessToken, String refreshToken) {
    var uri = url(
        "${MyUtils.type}${MyUtils.authContextPath}${StaticNamesPath.refresh.path}",
        queryParameters: {"refresh_token": refreshToken});
    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      "app-id": MyUtils.clientId,
    };

    return httpCall((client) => client.put(uri, headers: headers),
        parseJson: (json) => AccessTokenResponse.fromJson(json));
  }

  Future<Result<Message>> authDevice(
      String accessToken, AuthDeviceRequest request) {
    var uri = url(
        "${MyUtils.type}${MyUtils.authContextPath}${StaticNamesPath.device.path}");
    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
    };

    return httpCall(
            (client) =>
                client.post(uri, body: jsonEncode(request), headers: headers),
            parseJson: (json) => Message.fromJson(json))
        .then((value) => Result(value.success, value.obj, value.error,
            value.stackTrace, value.errorMessage, value.obj));
  }

  Future<Result<Message>> authDeviceCode(
      String accessToken, AuthDeviceCodeRequest request) {
    var uri = url(
        "${MyUtils.type}${MyUtils.authContextPath}${StaticNamesPath.device.path}");
    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
    };

    return httpCall(
            (client) =>
                client.put(uri, body: jsonEncode(request), headers: headers),
            parseJson: (json) => Message.fromJson(json))
        .then((value) => Result(value.success, value.obj, value.error,
            value.stackTrace, value.errorMessage, value.obj));
  }

  Future<Result<Void>> closeSession(String accessToken) {
    var uri = url(
        "${MyUtils.type}${MyUtils.authContextPath}${StaticNamesPath.closeSession.path}");
    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
    };

    return httpCall((client) => client.put(uri, headers: headers));
  }

  Future<Result<Message>> sendAuthDeviceCode(
      String accessToken, String fingerprint) {
    var uri = url(
        "${MyUtils.type}${MyUtils.authContextPath}${StaticNamesPath.resendCode.path}",
        queryParameters: {"fingerprint": fingerprint});
    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
    };

    return httpCall((client) => client.get(uri, headers: headers),
            parseJson: (json) => Message.fromJson(json))
        .then((value) => Result(value.success, value.obj, value.error,
            value.stackTrace, value.errorMessage, value.obj));
  }

  Future<Result<CredentialResponse>> credentials(Map<String, String> body) {
    var uri = url("${MyUtils.type}${StaticNamesPath.credentials.path}");
    var headers = {
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
    };

    return httpCall((client) => client.post(uri, body: body, headers: headers),
        parseJson: (json) => CredentialResponse.fromJson(json));
  }

  Future<Response> detail(Map<String, dynamic> body) {
    var uri = url("${MyUtils.type}${StaticNamesPath.detail.path}",
        queryParameters: {"limit": "1000"});
    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString(),
    };

    return _httpService.response(
        (client) => client.post(uri, body: jsonEncode(body), headers: headers));
  }

  Future<Result<String>> mdetail(Map<String, dynamic> body) {
    var uri = url("${MyUtils.type}${StaticNamesPath.detail.path}",
        queryParameters: {"limit": "1000"});
    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString(),
    };

    return httpCall(
        (client) => client.post(uri, body: jsonEncode(body), headers: headers),
        parseJson: (json) => jsonEncode(json));
  }

  Future<Result<String>> pinpadPayment(PinPadPaymentRequest request) {
    var uri = url("${MyUtils.type}${StaticNamesPath.payment.path}");
    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString(),
    };

    return httpCall(
        (client) =>
            client.post(uri, body: jsonEncode(request), headers: headers),
        parseJson: (json) => jsonEncode(json));
  }

  Future<Result<String>> pinpadAnnul(
      String id, PinPadAnnulRequest request) async {
    var uri = url("${MyUtils.type}${StaticNamesPath.anull.path}",
        queryParameters: {"id": id});

    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString(),
    };
    return httpCall(
        (client) =>
            client.put(uri, body: jsonEncode(request), headers: headers),
        parseJson: (json) => jsonEncode(json));
  }

  Future<Response> simple(
      Map<String, String> params, Map<String, dynamic> body) {
    var uri = url("${MyUtils.type}${StaticNamesPath.simple.path}",
        queryParameters: params);
    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString(),
    };

    return _httpService.response(
        (client) => client.post(uri, body: jsonEncode(body), headers: headers));
  }

  Future<Result<String>> msimple(
      Map<String, String> params, Map<String, dynamic> body) {
    var uri = url("${MyUtils.type}${StaticNamesPath.simple.path}",
        queryParameters: params);
    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString(),
    };

    return httpCall(
        (client) => client.post(uri, body: jsonEncode(body), headers: headers),
        parseJson: (json) => jsonEncode(json));
  }

  Future<Result<String>> mTransactions(
      Map<String, String> params, Map<String, dynamic> body) {
    var uri = url("${MyUtils.type}${StaticNamesPath.transactions.path}",
        queryParameters: params);
    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString(),
    };

    return httpCall(
        (client) => client.post(uri, body: jsonEncode(body), headers: headers),
        parseJson: (json) => jsonEncode(json));
  }

  Future<Result<String>> openLote(Map<String, dynamic> body) async {
    body = await openLoteFormatted();
    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString(),
    };
    var uri = url("${MyUtils.type}${StaticNamesPath.openLote.path}");

    return httpCall(
        (client) => client.post(uri, body: jsonEncode(body), headers: headers),
        parseJson: (json) => jsonEncode(json));
  }

  Future<Result<Profile>> profile() {
    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
    };
    var uri = url("${MyUtils.type}${StaticNamesPath.profile.path}");

    return httpCall((client) => client.get(uri, headers: headers),
        parseJson: (json) => Profile.fromJson(json));
  }

  Future<Result<String>> closed(
      Map<String, String> params, Map<String, dynamic> body) async {
    var uri = url("${MyUtils.type}${StaticNamesPath.closeLote.path}",
        queryParameters: params);

    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString(),
    };

    return httpCall(
        (client) => client.post(uri, body: jsonEncode(body), headers: headers),
        parseJson: (json) => jsonEncode(json));
  }

  Future<Result<String>> anulatePayment(
      Map<String, String> params, Map body) async {
    var uri = url("${MyUtils.type}${StaticNamesPath.anull.path}",
        queryParameters: params);
    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString(),
    };
    return httpCall(
        (client) => client.put(uri, body: jsonEncode(body), headers: headers),
        parseJson: (json) => jsonEncode(json));
  }

  Future<Result<String>> payment(Map<String, dynamic> body) async {
    var uri = url("${MyUtils.type}${StaticNamesPath.payment2.path}",
        queryParameters: MyUtils.params);
    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString(),
    };
    return httpCall(
        (client) => client.post(uri, body: jsonEncode(body), headers: headers),
        parseJson: (json) => jsonEncode(json));
  }

  Future<Result<PaymentModel>> payment2(
      {required Map<String, String> params,
      required Map<String, dynamic> body}) async {
    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
    };

    var uri = url("${MyUtils.type}${StaticNamesPath.payment2.path}",
        queryParameters: params);

    return httpCall(
        (client) => client.post(
              uri,
              body: jsonEncode(body),
              headers: headers,
            ),
        parseJson: (json) => PaymentModel.fromJson(json));
  }

  Future<Result<AccessTokenResponse>> authorize(String auth) {
    var uri = url("${MyUtils.type}${StaticNamesPath.authorize.path}");

    var headers = {
      HttpHeaders.authorizationHeader: "Basic $auth",
    };

    return httpCall((client) => client.post(uri, headers: headers),
        parseJson: (json) => AccessTokenResponse.fromJson(json));
  }

  Future<Result<String>> echoTest() async {
    var params = await testFormatted();
    if (params == null) {
      return Result.fail(
          "Error al consultar la información del dispositivo", null);
    }

    var uri = url("${MyUtils.type}${StaticNamesPath.echoTest.path}");
    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString(),
    };
    return httpCall(
        (client) =>
            client.post(uri, headers: headers, body: jsonEncode(params)),
        parseJson: (json) => jsonEncode(json));
  }

  Future<Result<String>> mdevice(String identifier) {
    var uri = url("${MyUtils.type}${StaticNamesPath.pinpadDevice.path}",
        queryParameters: {"identifier": identifier});
    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString(),
    };
    return httpCall((client) => client.get(uri, headers: headers),
        parseJson: (json) => jsonEncode(json));
  }

  Future<Result<String>> mlastReport(Map<String, String> params) {
    var uri = url("${MyUtils.type}${StaticNamesPath.lastReport.path}",
        queryParameters: params);
    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString(),
    };
    return httpCall((client) => client.get(uri, headers: headers),
        parseJson: (json) => jsonEncode(json));
  }

  Future<Response> lastReport(Map<String, String> params) {
    var uri = url("${MyUtils.type}${StaticNamesPath.lastReport.path}",
        queryParameters: params);
    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString(),
    };
    return _httpService.response((client) => client.get(uri, headers: headers));
  }

  Future<Result<Init>> init(String businessId, String role) async {
    Map<String, String> params = {};
    if (role == "servicepay") {
      params["client_id"] = MyUtils.clientIdServicePay;
    } else {
      params["client_id"] = MyUtils.clientIdPos;
    }
    params["role_owner_id"] = businessId;

    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
    };
    var token = await initHeaders();
    headers.addAll(token);

    var uri = url("${MyUtils.type}${StaticNamesPath.init.path}",
        queryParameters: params);

    return httpCall((client) => client.get(uri, headers: headers),
        parseJson: (json) => Init.fromJson(json));
  }

  Future<Result<Roles>> roles() async {
    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
    };
    var token = await initHeaders();
    headers.addAll(token);
    var uri = url("${MyUtils.type}${StaticNamesPath.roles.path}");

    return httpCall((client) => client.get(uri, headers: headers),
        parseJson: (json) => Roles.fromJson(json));
  }

  Future<Result<AccountModel>> account(
      {required String service, required String account}) async {
    Map<String, String> params = {"service": service, "account": account};
    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
    };

    var uri = url("${MyUtils.type}${StaticNamesPath.account.path}",
        queryParameters: params);

    return httpCall((client) => client.get(uri, headers: headers),
        parseJson: (json) => AccountModel.fromJson(json));
  }

  Future<Result<InventoryModel>> inventory(
      {required Map<String, String> params}) async {
    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
    };

    var uri = url("${MyUtils.type}${StaticNamesPath.inventory.path}",
        queryParameters: params);

    return httpCall((client) => client.get(uri, headers: headers),
        parseJson: (json) => InventoryModel.fromJson(json));
  }

  Future<Result<String>> balancePayment(
      {required Map<String, dynamic> body,
      required Map<String, String> params}) async {
    var uri = url(
        "${MyUtils.type}${MyUtils.urlContextPath}${StaticNamesPath.balancePayment.path}",
        queryParameters: params);

    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString(),
    };

    return httpCall(
        (client) => client.post(uri, body: jsonEncode(body), headers: headers),
        parseJson: (json) => jsonEncode(json));
  }

  Future<Result<CollectChannel>> getBanks(
      {required Map<String, String> params}) async {
    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
    };

    var uri = url("${MyUtils.type}${StaticNamesPath.banks.path}",
        queryParameters: params);

    return httpCall((client) => client.get(uri, headers: headers),
        parseJson: (json) => CollectChannel.fromJson(json));
  }

  Future<Result<CurrencyRate>> getRate(
      {required Map<String, String> params,
      required Map<String, dynamic> body}) async {
    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
    };

    var uri = url("${MyUtils.type}${StaticNamesPath.rate.path}",
        queryParameters: params);

    return httpCall(
        (client) => client.post(uri, headers: headers, body: jsonEncode(body)),
        parseJson: (json) => CurrencyRate.fromJson(json));
  }

  Future<Result<DetailsReportModel>> getDetails(
      {required Map<String, String> params,
      required Map<String, dynamic> body}) async {
    var headers = {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
    };

    var uri = url("${MyUtils.type}${StaticNamesPath.details.path}",
        queryParameters: params);

    return httpCall(
        (client) => client.post(uri, headers: headers, body: jsonEncode(body)),
        parseJson: (json) => DetailsReportModel.fromJson(json));
  }
}
