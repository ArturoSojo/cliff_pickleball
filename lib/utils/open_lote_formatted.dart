import 'package:cliff_pickleball/domain/merchant_affiliation.dart';
import 'package:cliff_pickleball/services/cacheService.dart';

Cache _cache = Cache();

String? _formattedChannel(String? terminal) {
  switch (terminal) {
    case "IST77":
      return "MC77";
    case "IST73":
      return "MC73";
    default:
      terminal;
  }
}

Future<dynamic> openLoteFormatted() async {
  Map<String, dynamic> body = {
    "affiliation": [
      {"affiliation_number": "", "terminals": []}
    ]
  };
  var resultBody = await _cache.getDeviceInformation();
  if (resultBody!.device!.merchantAffiliations![0].affiliationNumber != null) {
    body["affiliation"][0]["affiliation_number"] =
        resultBody.device!.merchantAffiliations![0].affiliationNumber;
  }
  if (resultBody.device!.merchantAffiliations![0].terminals != null) {
    if (resultBody.device!.merchantAffiliations![0].terminals != null) {
      if (resultBody.device!.merchantAffiliations![0]
              .terminals![TransactionType.CREDIT] !=
          null) {
        Map<String, dynamic> TDC = {};
        TDC["terminal"] = resultBody.device!.merchantAffiliations![0]
            .terminals![TransactionType.CREDIT];
        TDC["type"] = "CREDITO";

        TDC["channel"] = _formattedChannel(resultBody
            .device!
            .merchantAffiliations![0]
            .bankTransactionalPaymentChannel?[PaymentCardType.TDC]
            ?.name);
        body["affiliation"][0]["terminals"].add(TDC);
      }
      if (resultBody.device!.merchantAffiliations![0]
              .terminals![TransactionType.DEBIT] !=
          null) {
        Map<String, dynamic> TDD = {};
        TDD["terminal"] = resultBody
            .device!.merchantAffiliations![0].terminals![TransactionType.DEBIT];
        TDD["type"] = "DEBITO";
        TDD["channel"] = _formattedChannel(resultBody
            .device!
            .merchantAffiliations![0]
            .bankTransactionalPaymentChannel?[PaymentCardType.TDD]
            ?.name);
        body["affiliation"][0]["terminals"].add(TDD);
      }
    }
  }
  return body;
}
