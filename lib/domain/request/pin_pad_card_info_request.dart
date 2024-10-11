import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pin_pad_card_info_request.freezed.dart';
part 'pin_pad_card_info_request.g.dart';

@freezed
class PinPadCardInfoRequest with _$PinPadCardInfoRequest {
  @JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
  const factory PinPadCardInfoRequest({
    String? chip,
    String? track1,
    String? track2,
    String? track3,
    String? pinb,
    String? ksn,
    String? ksnp,
  }) = _PinPadCardInfoRequest;

  factory PinPadCardInfoRequest.fromJson(Map<String, Object?> json) =>
      _$PinPadCardInfoRequestFromJson(json);
}
