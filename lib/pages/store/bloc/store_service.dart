import '../../../di/injection.dart';
import '../../../services/cacheService.dart';
import '../../../services/http/api_services.dart';
import '../../../services/http/result.dart';
import '../models/store_model.dart';

final _apiServices = getIt<ApiServices>();
final _cache = Cache();

Future<Result<InventoryModel>> getInventory() async {
  var init = await _cache.getInitData("servicepay");
  Map<String, String> params = {
    "realm": init?.initData?.ally?.realm ?? "",
    "business_id": init?.initData?.ally?.id ?? "",
    "type": "PAGINATE",
    "limit": "10",
  };

  return await _apiServices.inventory(params: params);
}


