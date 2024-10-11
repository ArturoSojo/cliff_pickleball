import 'package:injectable/injectable.dart';
import 'package:cliff_pickleball/domain/request/pin_pad_card_info_request.dart';
import 'package:cliff_pickleball/domain/request/pin_pad_payment_request.dart';
import 'package:cliff_pickleball/services/http/api_services.dart';

import '../../services/http/result.dart';

@injectable
class NewSaleService {
  final ApiServices _apiServices;

  NewSaleService(this._apiServices);

  Future<Result<String>> payment(
      String deviceIdentifier,
      String cardHolderId,
      double amount,
      AccountType accountType,
      PaymentCardType paymentCardType,
      String chip) {
    cardHolderId = cardHolderId.padLeft(9, "0");

    var request = PinPadPaymentRequest(
        emv: Emv.SI,
        amount: amount,
        accountType: accountType,
        deviceIdentifier: deviceIdentifier,
        cardHolderId: cardHolderId,
        cardHolderIdType: IdType.CI,
        currency: "VED",
        modePan: ModePan.CHIP,
        modePin: ModePin.PIN,
        paymentCardType: paymentCardType,
        merchant: PinPadCardInfoRequest(chip: chip));

    return _apiServices.pinpadPayment(request);
  }
}
