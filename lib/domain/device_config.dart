import 'package:json_annotation/json_annotation.dart';

part 'device_config.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class DeviceConfig {
  String? id;
  String? businessName;
  String? businessEmail;
  String? businessIdDoc;
  String? businessPhone;
  String? identifier;
  String? name;
  String? serial;
  String? imei;
  String? brand;
  String? model;
  String? version;
  String? commerceId;
  String? commerceName;
  String? commerceEmail;
  String? commerceIdDoc;
  String? appVersion;
  String? commercePassword;
  String? keysPassword;
  String? connectionType;
  String? phonePrefix;
  String? dialType;
  String? callType;
  String? hostname;
  String? tpdu;
  String? tpduReload;
  String? serverName;
  String? serverIp;
  int? serverPort;
  String? tmsIp;
  int? tmsPort;
  bool? functionalityIncluded;
  int? connectionRetries;
  bool? offlineCashAdvancementEnable;
  bool? closureEnable;
  bool? closureRequest;
  int? lotClosureDays;
  bool? rechargeEnable;
  bool? extraFinancingEnable;
  int? timeout;
  String? extraFinancingLiteral;
  bool? requestAnnulationPassword;
  bool? requestReturnPassword;
  bool? requestCashAdvancementPassword;
  bool? requestReportPassword;
  bool? requestInstallerPassword;
  bool? requestOperatorPassword;
  bool? requestSyncPassword;
  bool? requestLoadKeysPassword;
  String? annulationPassword;
  String? returnPassword;
  String? cashAdvancementPassword;
  String? reportPassword;
  String? installerPassword;
  String? operatorPassword;
  String? syncPassword;
  String? loadKeysPassword;
  bool? printReceiptEnable;
  bool? displayReceiptEnable;
  bool? sessionEnable;
  int? inactivityTime;
  String? affiliationType;
  String? dataEntry;
  String? coin;
  int? percentageTip;
  List<String>? readingTypes;
  bool? sendOnlyDefaultConnection;
  int? forcedCloseTime;
  String? forcedCloseTimeUnit;

  DeviceConfig(
      {this.id,
      this.businessName,
      this.businessEmail,
      this.businessIdDoc,
      this.businessPhone,
      this.identifier,
      this.name,
      this.serial,
      this.imei,
      this.brand,
      this.model,
      this.version,
      this.commerceId,
      this.commerceName,
      this.commerceEmail,
      this.commerceIdDoc,
      this.appVersion,
      this.commercePassword,
      this.keysPassword,
      this.connectionType,
      this.phonePrefix,
      this.dialType,
      this.callType,
      this.hostname,
      this.tpdu,
      this.tpduReload,
      this.serverName,
      this.serverIp,
      this.serverPort,
      this.tmsIp,
      this.tmsPort,
      this.functionalityIncluded,
      this.connectionRetries,
      this.offlineCashAdvancementEnable,
      this.closureEnable,
      this.closureRequest,
      this.lotClosureDays,
      this.rechargeEnable,
      this.extraFinancingEnable,
      this.timeout,
      this.extraFinancingLiteral,
      this.requestAnnulationPassword,
      this.requestReturnPassword,
      this.requestCashAdvancementPassword,
      this.requestReportPassword,
      this.requestInstallerPassword,
      this.requestOperatorPassword,
      this.requestSyncPassword,
      this.requestLoadKeysPassword,
      this.annulationPassword,
      this.returnPassword,
      this.cashAdvancementPassword,
      this.reportPassword,
      this.installerPassword,
      this.operatorPassword,
      this.syncPassword,
      this.loadKeysPassword,
      this.printReceiptEnable,
      this.displayReceiptEnable,
      this.sessionEnable,
      this.inactivityTime,
      this.affiliationType,
      this.dataEntry,
      this.coin,
      this.percentageTip,
      this.readingTypes,
      this.sendOnlyDefaultConnection,
      this.forcedCloseTime,
      this.forcedCloseTimeUnit});

  factory DeviceConfig.fromJson(Map<String, dynamic> json) =>
      _$DeviceConfigFromJson(json);

  /// Connect the generated [_$DeviceConfigToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$DeviceConfigToJson(this);
}
