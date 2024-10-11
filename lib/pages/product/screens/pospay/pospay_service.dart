
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:ffi';

import '../../../../di/injection.dart';
import '../../../../services/cacheService.dart';
import '../../../../services/http/api_services.dart';
import '../../../../services/http/domain/productModel.dart';
import '../../../../services/http/result.dart';
import '../prepay/models/payment_model.dart';
import 'models/account_model.dart';

final _apiServices = getIt<ApiServices>();
final _cache = Cache();

Future<Result<AccountModel>> getResponsePos(ProductModel product, String account, bool completeAccount) async {
  return await _apiServices.account(service: product.name ?? "", account: account);
}

Future<Result<PaymentModel>> sendPaymentPospay(
    {required ProductModel product, required String acc, required double debt, required String payment_method}) async {
  var init = await _cache.getInitData("servicepay");

  Map<String, String> params = {
    "realm": init?.initData?.ally?.realm ?? "",
    "business_id": init?.initData?.ally?.businessId ?? "",
    "user_id": init?.initData?.ally?.id ?? "",
    "user_email": init?.initData?.ally?.allyEmail ?? "",
    "country": "VE",
    "service_type": product.name ?? ""
  };

  Map<String, dynamic> body = {
    "account_number": acc,
    "amount": debt,
    "payment_method": payment_method
  };

  return await _apiServices.payment2(params: params, body: body);

}
