class TransactionsModel {
  String? firstPage;
  String? lastPage;
  int? count;
  List<Results>? results;

  TransactionsModel({this.firstPage, this.lastPage, this.count, this.results});

  TransactionsModel.fromJson(Map<String, dynamic> json) {
    firstPage = json['first_page'];
    lastPage = json['last_page'];
    count = json['count'];
    if (json['results'] != null) {
      if(json["results"].length!=0){
        results = <Results>[];
        json['results'].forEach((v) {
          if(v!=null){
            results?.add(new Results.fromJson(v));
          }
        });
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_page'] = this.firstPage;
    data['last_page'] = this.lastPage;
    data['count'] = this.count;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  String? timestamp;
  String? id;
  String? profileIdAcquiring;
  String? lotNumber;
  String? affiliationNumber;
  String? paymentMethodId;
  String? accountType;
  int? amount;
  String? cardName;
  String? cardHolder;
  String? cardHolderId;
  String? cardHolderNumberMask;
  String? coin;
  String? deviceId;
  String? orderNumber;
  String? statusId;
  String? approval;
  bool? deferred;
  String? message;
  String? reference;
  String? responseCode;
  String? sequence;
  String? status;
  bool? success;
  String? cycleId;
  String? channelType;
  Store? store;
  int? currencyIsoNumber;
  String? collectorName;
  String? collectorIdDoc;
  String? collectorBankName;
  String? collectorBankRif;
  String? istTime;
  String? istDate;

  Results({this.timestamp, this.id, this.profileIdAcquiring, this.lotNumber, this.affiliationNumber, this.paymentMethodId, this.accountType, this.amount, this.cardName, this.cardHolder, this.cardHolderId, this.cardHolderNumberMask, this.coin, this.deviceId, this.orderNumber, this.statusId, this.approval, this.deferred, this.message, this.reference, this.responseCode, this.sequence, this.status, this.success, this.cycleId, this.channelType, this.store, this.currencyIsoNumber, this.collectorName, this.collectorIdDoc, this.collectorBankName, this.collectorBankRif, this.istTime, this.istDate});

  Results.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'];
    id = json['id'];
    profileIdAcquiring = json['profile_id_acquiring'];
    lotNumber = json['lot_number'];
    affiliationNumber = json['affiliation_number'];
    paymentMethodId = json['payment_method_id'];
    accountType = json['account_type'];
    amount = json['amount'];
    cardName = json['card_name'];
    cardHolder = json['card_holder'];
    cardHolderId = json['card_holder_id'];
    cardHolderNumberMask = json['card_holder_number_mask'];
    coin = json['coin'];
    deviceId = json['device_id'];
    orderNumber = json['order_number'];
    statusId = json['status_id'];
    approval = json['approval'];
    deferred = json['deferred'];
    message = json['message'];
    reference = json['reference'];
    responseCode = json['response_code'];
    sequence = json['sequence'];
    status = json['status'];
    success = json['success'];
    cycleId = json['cycle_id'];
    channelType = json['channel_type'];
    store = json['store'] != null ? new Store.fromJson(json['store']) : null;
    currencyIsoNumber = json['currency_iso_number'];
    collectorName = json['collector_name'];
    collectorIdDoc = json['collector_id_doc'];
    collectorBankName = json['collector_bank_name'];
    collectorBankRif = json['collector_bank_rif'];
    istTime = json['ist_time'];
    istDate = json['ist_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['timestamp'] = this.timestamp;
    data['id'] = this.id;
    data['profile_id_acquiring'] = this.profileIdAcquiring;
    data['lot_number'] = this.lotNumber;
    data['affiliation_number'] = this.affiliationNumber;
    data['payment_method_id'] = this.paymentMethodId;
    data['account_type'] = this.accountType;
    data['amount'] = this.amount;
    data['card_name'] = this.cardName;
    data['card_holder'] = this.cardHolder;
    data['card_holder_id'] = this.cardHolderId;
    data['card_holder_number_mask'] = this.cardHolderNumberMask;
    data['coin'] = this.coin;
    data['device_id'] = this.deviceId;
    data['order_number'] = this.orderNumber;
    data['status_id'] = this.statusId;
    data['approval'] = this.approval;
    data['deferred'] = this.deferred;
    data['message'] = this.message;
    data['reference'] = this.reference;
    data['response_code'] = this.responseCode;
    data['sequence'] = this.sequence;
    data['status'] = this.status;
    data['success'] = this.success;
    data['cycle_id'] = this.cycleId;
    data['channel_type'] = this.channelType;
    if (this.store != null) {
      data['store'] = this.store?.toJson();
    }
    data['currency_iso_number'] = this.currencyIsoNumber;
    data['collector_name'] = this.collectorName;
    data['collector_id_doc'] = this.collectorIdDoc;
    data['collector_bank_name'] = this.collectorBankName;
    data['collector_bank_rif'] = this.collectorBankRif;
    data['ist_time'] = this.istTime;
    data['ist_date'] = this.istDate;
    return data;
  }
}

class Store {
  // List<String?> emails;
  String? address;
  String? name;
  String? id;
  String? status;

  Store({this.address, this.name, this.id, this.status});

  Store.fromJson(Map<String, dynamic> json) {
    // if (json['emails'] != null) {
    //   emails = List<String>();
    //   json['emails'].forEach((v) { emails.add(new Null.fromJson(v)); });
    // }
    address = json['address'];
    name = json['name'];
    id = json['id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // if (this.emails != null) {
    //   data['emails'] = this.emails.map((v) => v.toJson()).toList();
    // }
    data['address'] = this.address;
    data['name'] = this.name;

    data['id'] = this.id;
    data['status'] = this.status;
    return data;
  }
}



Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  return data;
}
