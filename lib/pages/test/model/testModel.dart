import '../../../domain/merchant_affiliation.dart';

class TestModel {
  bool? success;
  String? message;
  String? responceCode;
  bool? deferred;
  String? datetime;
  int? amount;
  String? channel;

  TestModel(
      {this.success,
      this.message,
      this.responceCode,
      this.deferred,
      this.datetime,
      this.amount,
      this.channel});

  TestModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    responceCode = json['responce_code'];
    deferred = json['deferred'];
    datetime = json['datetime'];
    amount = json['amount'];
    channel = formattedChannel(json['channel']);
  }

  String? formattedChannel(String? channel) {
    switch (channel) {
      case "MC77":
        return "IST77";
      case "MC73":
        return "IST73";
      default:
        return channel;
    }
  }

  String? reloadformattedChannel(TransactionalChannel channel) {
    switch (channel) {
      case TransactionalChannel.CHANNEL_7_3:
        return "MC73";
        break;
      case TransactionalChannel.CHANNEL_7_7:
        return "MC77";
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['responce_code'] = this.responceCode;
    data['deferred'] = this.deferred;
    data['datetime'] = this.datetime;
    data['amount'] = this.amount;
    data['channel'] = this.channel;
    return data;
  }
}
