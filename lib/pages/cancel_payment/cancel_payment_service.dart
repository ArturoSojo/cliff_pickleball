import 'package:injectable/injectable.dart';

import '../../domain/request/pin_pad_annul_request.dart';
import '../../domain/request/pin_pad_card_info_request.dart';
import '../../domain/request/pin_pad_payment_request.dart';
import '../../services/cacheService.dart';
import '../../services/http/api_services.dart';
import '../../services/http/result.dart';

@injectable
class CancelPaymentService {
  final Cache _cache;
  final ApiServices _apiServices;

  CancelPaymentService(this._apiServices, this._cache);

  Future<Result<String>> annul(String id, String cardHolderId,
      String accountType, String chip) async {
    var deviceIdentifier =
        (await _cache.getDeviceInformation())?.device?.identifier;

    if (deviceIdentifier == null) {
      return Result.failMsg("DEVICE IDENTIFIER IS NULL");
    }

    cardHolderId = cardHolderId.padLeft(9, "0");

    var request = PinPadAnnulRequest(
        emv: Emv.SI,
        accountType: accountType,
        deviceIdentifier: deviceIdentifier,
        cardHolderId: cardHolderId,
        modePan: ModePan.CHIP,
        modePin: ModePin.PIN,
        merchant: PinPadCardInfoRequest(chip: chip));

    return _apiServices.pinpadAnnul(id, request);
  }
}
