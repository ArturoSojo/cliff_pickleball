import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cliff_pickleball/domain/request/pin_pad_card_info_request.dart';
import 'package:cliff_pickleball/domain/request/pin_pad_payment_request.dart';

part 'pin_pad_annul_request.freezed.dart';
part 'pin_pad_annul_request.g.dart';

@freezed
class PinPadAnnulRequest with _$PinPadAnnulRequest {
  @JsonSerializable(
      explicitToJson: true,
      fieldRename: FieldRename.snake,
      includeIfNull: false)
  const factory PinPadAnnulRequest({
    required Emv emv,
    required String cardHolderId,
    required ModePan modePan,
    required ModePin modePin,
    required PinPadCardInfoRequest merchant,
    required String accountType,
    required String deviceIdentifier,
  }) = _PinPadAnnulRequest;

  factory PinPadAnnulRequest.fromJson(Map<String, Object?> json) =>
      _$PinPadAnnulRequestFromJson(json);
}
