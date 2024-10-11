import 'package:freezed_annotation/freezed_annotation.dart';

part 'operation.freezed.dart';
part 'operation.g.dart';

@freezed
class Operation with _$Operation {
  @JsonSerializable(
      explicitToJson: true,
      fieldRename: FieldRename.snake,
      includeIfNull: false)
  const factory Operation({
    required String id,
    //required String orderId,
    required String lotNumber,
    required String accountType,
    required String affiliationNumber,
    required String amount,
    required String cardHolderId,
  }) = _Operation;

  factory Operation.fromJson(Map<String, Object?> json) =>
      _$OperationFromJson(json);
}
