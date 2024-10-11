import '../../../di/injection.dart';
import '../../../services/cacheService.dart';
import '../../../services/http/api_services.dart';
import '../../../services/http/result.dart';
import '../../store/models/collect_channel_model.dart';
import '../../store/models/rate_model.dart';

final _apiService = getIt<ApiServices>();
final _cache = Cache();

Future<Result<String>> rechargePayment({
    required String product_name,
    required String collect_method_id,
    required String inventory_type,
    required String payerBankCode,
    required num amount,
    required String dni,
    required String phone,
    required String reference
  }) async {
  var init = await _cache.getInitData("servicepay");

  Map<String, String> params = {
    "realm": init?.initData?.ally?.realm ?? "",
    "business_id": init?.initData?.ally?.businessId ?? "",
    "user_id": init?.initData?.ally?.id ?? "",
    "user_email": init?.initData?.ally?.allyEmail ?? "",
    "country": "VE",
  };

  Map<String, dynamic> body = {
    "product_name": product_name,
    "collect_method_id": collect_method_id,
    "inventory_type": inventory_type,
    "amount": amount,
    "payment": {
      "payer_bank_code": payerBankCode,
      "amount": amount,
      "payer_id_doc": dni,
      "payer_phone": phone,
      "reference": reference
    }
  };
  return await _apiService.balancePayment(body: body, params: params);
}


Future<Result<CollectChannel>> getBanks() async {
  var init = await _cache.getInitData("servicepay");
  Map<String, String> params = {
    "realm": init?.initData?.ally?.realm ?? "",
    "business_id": init?.initData?.ally?.id ?? "",
  };

  return await _apiService.getBanks(params: params);
}

Future<Result<CurrencyRate>> getRate() async {

  var init = await _cache.getInitData("servicepay");

  Map<String, String> params = {
    "realm": init?.initData?.ally?.realm ?? "",
    "business_id": init?.initData?.ally?.id ?? "",
    "type": "PAGINATE",
    "limit": "1"
  };

  Map<String, dynamic> body = {
    "sort":{"CREATED_AT":"desc"}
  };

  return await _apiService.getRate(params: params, body: body);
}