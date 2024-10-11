import 'package:cliff_pickleball/utils/tlv_comparator.dart';

abstract class PaymentQposListener {
  void deviceDisconnected();

  void enterCard();

  String getAmount();

  void error(String? parameters);

  void aidFound(AidInfo aidInfo);

  void requestPin();

  void display(String parameters);

  void chipFound(String chip);

  void cardApproved();
}
