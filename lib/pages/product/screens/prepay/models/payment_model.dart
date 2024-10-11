import 'package:intl/intl.dart';
import '../../../../../utils/translate.dart';

class PaymentModel {
  String? realm;
  String? businessId;
  int? intDate;
  String? id;
  String? businessName;
  String? businessEmail;
  String? businessIdDoc;
  String? businessIdDocType;
  int? sequence;
  double? amount;
  String? formattedAmount;
  String? ip;
  String? userAgent;
  String? service;
  String? formattedService;
  String? accountNumber;
  String? operation;
  String? paymentMethod;
  String? approvedNumber;
  String? isoMsg;
  String? responseCode;
  String? responseData;
  String? acknowledgeAt;
  String? inventoryId;
  String? inventoryType;
  String? inventoryName;
  String? inventoryUnit;
  String? inventoryExternalSapCode;
  String? inventoryFeeChargeType;
  double? transactionFee;
  double? transactionFeeAmount;
  String? createdBy;
  String? createdByEmail;
  String? createdAt;
  String? formattedCreatedAt;
  String? status;
  String? formattedStatus;
  double? serviceCommissionPerTransaction;
  double? serviceCommissionPerTransactionAmount;
  SharesAmount? sharesAmount;
  String? channel;

  PaymentModel(
      {this.realm,
        this.businessId,
        this.intDate,
        this.id,
        this.businessName,
        this.businessEmail,
        this.businessIdDoc,
        this.businessIdDocType,
        this.sequence,
        this.amount,
        this.formattedAmount,
        this.ip,
        this.userAgent,
        this.service,
        this.formattedService,
        this.accountNumber,
        this.operation,
        this.paymentMethod,
        this.approvedNumber,
        this.isoMsg,
        this.responseCode,
        this.responseData,
        this.acknowledgeAt,
        this.inventoryId,
        this.inventoryType,
        this.inventoryName,
        this.inventoryUnit,
        this.inventoryExternalSapCode,
        this.inventoryFeeChargeType,
        this.transactionFee,
        this.transactionFeeAmount,
        this.createdBy,
        this.formattedCreatedAt,
        this.createdByEmail,
        this.createdAt,
        this.status,
        this.formattedStatus,
        this.serviceCommissionPerTransaction,
        this.serviceCommissionPerTransactionAmount,
        this.sharesAmount,
        this.channel});

  PaymentModel.fromJson(Map<String, dynamic> json) {
    final DateFormat _formattedDate = DateFormat("dd-MM-yy");
    NumberFormat numFormat = NumberFormat('###,##0.00', 'es_VE');

    realm = json['realm'];
    businessId = json['business_id'];
    intDate = json['int_date'];
    id = json['id'];
    businessName = json['business_name'];
    businessEmail = json['business_email'];
    businessIdDoc = json['business_id_doc'];
    businessIdDocType = json['business_id_doc_type'];
    sequence = json['sequence'];
    amount = json['amount'];
    formattedAmount = json['amount'] != null ? numFormat.format(double.parse(json["amount"].toString())) : json['amount'];
    ip = json['ip'];
    userAgent = json['user_agent'];
    service = json['service'];
    formattedService = json['service'] != null ? translate(json['service']) : json['service'];
    accountNumber = json['account_number'];
    operation = json['operation'];
    paymentMethod = json['payment_method'];
    approvedNumber = json['approved_number'];
    isoMsg = json['iso_msg'];
    responseCode = json['response_code'];
    responseData = json['response_data'];
    acknowledgeAt = json['acknowledge_at'];
    inventoryId = json['inventory_id'];
    inventoryType = json['inventory_type'];
    inventoryName = json['inventory_name'];
    inventoryUnit = json['inventory_unit'];
    inventoryExternalSapCode = json['inventory_external_sap_code'];
    inventoryFeeChargeType = json['inventory_fee_charge_type'];
    // transactionFee = json['transaction_fee'];
    // transactionFeeAmount = json['transaction_fee_amount'];
    createdBy = json['created_by'];
    createdByEmail = json['created_by_email'];
    createdAt = json['created_at'];
    formattedCreatedAt = json['created_at'] != null ?
    _formattedDate.format(DateTime.parse(json['created_at']).toLocal()): json['created_at'];
    status = json['status'];
    formattedStatus = translate(json['status']);
    serviceCommissionPerTransaction =
    json['service_commission_per_transaction']!=null
        ? double.parse(json['service_commission_per_transaction'].toString())
        : json['service_commission_per_transaction'];
    serviceCommissionPerTransactionAmount =
    json['service_commission_per_transaction_amount'];
    // sharesAmount = json['shares_amount'] != null
    //     ? new SharesAmount.fromJson(json['shares_amount'])
    //     : null;
    channel = json['channel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['realm'] = this.realm;
    data['business_id'] = this.businessId;
    data['int_date'] = this.intDate;
    data['id'] = this.id;
    data['business_name'] = this.businessName;
    data['business_email'] = this.businessEmail;
    data['business_id_doc'] = this.businessIdDoc;
    data['business_id_doc_type'] = this.businessIdDocType;
    data['sequence'] = this.sequence;
    data['amount'] = this.amount;
    data['ip'] = this.ip;
    data['user_agent'] = this.userAgent;
    data['service'] = this.service;
    data['account_number'] = this.accountNumber;
    data['operation'] = this.operation;
    data['payment_method'] = this.paymentMethod;
    data['approved_number'] = this.approvedNumber;
    data['iso_msg'] = this.isoMsg;
    data['response_code'] = this.responseCode;
    data['response_data'] = this.responseData;
    data['acknowledge_at'] = this.acknowledgeAt;
    data['inventory_id'] = this.inventoryId;
    data['inventory_type'] = this.inventoryType;
    data['inventory_name'] = this.inventoryName;
    data['inventory_unit'] = this.inventoryUnit;
    data['inventory_external_sap_code'] = this.inventoryExternalSapCode;
    data['inventory_fee_charge_type'] = this.inventoryFeeChargeType;
    data['transaction_fee'] = this.transactionFee;
    data['transaction_fee_amount'] = this.transactionFeeAmount;
    data['created_by'] = this.createdBy;
    data['created_by_email'] = this.createdByEmail;
    data['created_at'] = this.createdAt;
    data['status'] = this.status;
    data['service_commission_per_transaction'] =
        this.serviceCommissionPerTransaction;
    data['service_commission_per_transaction_amount'] =
        this.serviceCommissionPerTransactionAmount;
    if (this.sharesAmount != null) {
      data['shares_amount'] = this.sharesAmount?.toJson();
    }
    data['channel'] = this.channel;
    return data;
  }
}

class SharesAmount {
  double? aLLY;

  SharesAmount({this.aLLY});

  SharesAmount.fromJson(Map<String, dynamic> json) {
    aLLY = json['ALLY'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ALLY'] = this.aLLY;
    return data;
  }
}
