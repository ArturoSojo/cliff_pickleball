import 'package:logger/logger.dart';
import '../../../di/injection.dart';
import '../../../services/cacheService.dart';
import '../../../services/http/api_services.dart';
import '../../../services/http/result.dart';
import '../models/details_report_model.dart';

final _apiServices = getIt<ApiServices>();
final _logger = Logger();
final _cache = Cache();

Future<Result<DetailsReportModel>> getInventory({
  required String offset,
  required String limit,
  required String inventoryType,
  required String gte,
  required String lte,
  required String timezone}) async {

  var init = await _cache.getInitData("servicepay");

  Map<String, String> params = {
    "realm": init?.initData?.ally?.realm ?? "",
    "business_id": init?.initData?.ally?.id ?? "",
    "type": "PAGINATE",
    "offset": offset,
    "limit": limit,
  };

  Map<String, dynamic> body = {
    "inventory_type": [inventoryType],
    "timestamp": {
      "gte": gte,
      "lte": lte,
      "time_zone": timezone
    }
  };

  return await _apiServices.getDetails(params: params, body: body);
}