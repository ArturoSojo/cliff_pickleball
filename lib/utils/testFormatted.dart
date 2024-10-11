import 'package:cliff_pickleball/services/cacheService.dart';

var _cache = Cache();

Future<dynamic> testFormatted() async {
  Map<String, dynamic> params = {};

  var merchant = await _cache.getDeviceInformation();
  if (merchant!.config != null) {
    params["version_app"] = merchant.config!.appVersion ?? "";
  } else {
    params["version_app"] = validateAppVersion(merchant.device!.model ?? "");
  }
  if (merchant.device!.merchantAffiliations![0].affiliationNumber != null) {
    params["affiliation_number"] =
        merchant.device!.merchantAffiliations![0].affiliationNumber ?? "";
  }
  params["currency"] = "Bs.";
  if (merchant.device!.merchantAffiliations![0].terminalSet!.length != 0) {
    params["terminal"] =
        merchant.device!.merchantAffiliations![0].terminalSet?.first ?? "";
  }
  params["channels"] = ["MC77", "MC73"];

  return params;
}

String validateAppVersion(String? version) {
  switch (version) {
    case "QPOS_MINI":
      return "PPQP000002";
    case "QPOS MINI":
      return "PPQP000002";
    case "QPOS_CUTE":
      return "PPCUT00001";
    case "QPOS CUTE":
      return "PPCUT00001";
    case "CR100":
      return "PPQP000002";
    default:
      return "";
  }
}
