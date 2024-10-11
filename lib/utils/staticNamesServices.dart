import 'package:cliff_pickleball/utils/utils.dart';

import 'path_name.dart';

class StaticNamesPath {
  static Path passwordGrant = Path("/password_grant");
  static Path refresh = Path("/refresh");
  static Path authorize = Path("/oauth/authorize");
  static Path device = Path("/device");
  static Path closeSession = Path("/close_session");
  static Path resendCode = Path("/resend_code");
  static Path credentials = Path("/oauth/info_from_credentials");
  static Path openLote = Path("/merchant/lote_open_affiliation");
  static Path profile = Path("${MyUtils.urlContextPath}/my_profile");
  static Path closeLote = Path("/merchant/lote_close_merchant_affiliation");
  static Path payment = Path("${MyUtils.urlContextPath}/pin_pad/payment");
  static Path anull = Path("${MyUtils.urlContextPath}/pin_pad/annul");
  static Path detail = Path("/merchant/cycle_transaction_report");
  static Path simple = Path("/merchant/cycle_transaction_aggregation");
  static Path transactions = Path("/merchant/cycle_transaction_report");
  static Path echoTest = Path("/merchant/echo_test_v2");
  static Path pinpadDevice =
      Path("${MyUtils.urlContextPath}/wallet_device/by_commerce_identifier");
  static Path lastReport =
      Path("/merchant/bankgateway_transaction/device_last_transaction");
  static Path init = Path("${MyUtils.authContextPath}/init");
  static Path roles = Path("${MyUtils.authContextPath}/roles");
  static Path account =
      Path("${MyUtils.urlContextPath}/service_pay/consultation");
  static Path inventory =
      Path("${MyUtils.urlContextPath}/service_pay_inventory/get2");
  static Path balancePayment = Path("/service_pay_payment/balance_payment");
  static Path banks =
      Path("${MyUtils.urlContextPath}/service_pay_payment/collect_channel");
  static Path rate =
      Path("${MyUtils.urlContextPath}/currency_exchange_rate/report");
  static Path details =
      Path("${MyUtils.urlContextPath}/service_pay_inventory_movement/report");
  static Path payment2 = Path("${MyUtils.urlContextPath}/service_pay/payment");
}
