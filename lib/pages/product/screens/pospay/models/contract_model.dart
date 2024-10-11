import 'package:intl/intl.dart';

class ContractModel {
  String? name;
  double? balance;
  double? daysLeftOfService;

  ContractModel({this.name, this.balance, this.daysLeftOfService});

  ContractModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    balance = json['balance'];
    daysLeftOfService = json['days_left_of_service'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['balance'] = this.balance;
    data['days_left_of_service'] = this.daysLeftOfService;
    return data;
  }
}