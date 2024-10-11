import '../../domain/access_token_response.dart';
import '../../pages/new_sale/models/initModel.dart';
import '../../utils/utils.dart';
import '../cacheService.dart';

final _cache = Cache();

Future<Map<String, String>> initHeaders() async {
  Map<String, String> headers = {};

  AccessTokenResponse? access = await _cache.getAccessTokenResponse();
  var token = access?.accessToken;

  if(token != null){
    headers["Authorization"] = "bearer $token";
  }
  return headers;
}

/* Future<Map<String, String>> initParams() async {
  Init? init = await _cache.getInitData("servicepay");
  Map<String, String> params = {};
  params["client_id"] = MyUtils.clientId;
  if(init?.role?.businessId!=null){
    params["role_owner_id"] = init?.role?.businessId ?? "";
  }
  return params;
} */