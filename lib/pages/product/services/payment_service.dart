import '../../../../services/http/result.dart';
import '../../../di/injection.dart';
import '../../../services/cacheService.dart';
import '../../../services/http/api_services.dart';
import '../../../services/http/domain/productModel.dart';
import '../screens/prepay/models/payment_model.dart';

final _apiServices = getIt<ApiServices>();
final _cache = Cache();

Future<Result<PaymentModel>> sendPayment({required ProductModel product, required amount, required String phone}) async {
  var init = await _cache.getInitData("servicepay");
  var profile = await _cache.getProfile();

  Map<String, String> params = {
    "realm": init?.initData?.ally?.realm ?? "",
    "business_id": init?.initData?.ally?.id ?? "",
    "user_id": init?.profile?.id ?? "",
    "user_email": init?.profile?.emailDeflt ?? "",
    "country": "VE",
    "service_type": product.name ?? ""
  };
  Map<String, dynamic> body = {
    "account_number": phone,
    "amount": amount,
    "payment_method": "CASH"
  };

  return await _apiServices.payment2(params: params, body: body);
}