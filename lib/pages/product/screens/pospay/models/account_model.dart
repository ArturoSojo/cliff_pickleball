import 'package:intl/intl.dart';

class AccountModel {

  NumberFormat numFormat = NumberFormat('###,###.00', 'es_VE');

  String? name;
  double? expiredDebt;
  double? totalDebt;
  double? currentDebt;

  String? formattedExpiredDebt;
  String? formattedTotalDebt;
  String? formattedCurrentDebt;

  double? balance;
  String? formattedBalance;
  int? daysLeftOfService;

  AccountModel(
      {this.name, this.expiredDebt, this.totalDebt, this.currentDebt, this.balance, this.daysLeftOfService});

  AccountModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    expiredDebt = json['expired_debt'];
    totalDebt = json['total_debt'];
    currentDebt = json['current_debt'];

    if(expiredDebt!=null){
      if(expiredDebt!=0){
        formattedExpiredDebt = expiredDebt!=null ? numFormat.format(expiredDebt) : expiredDebt.toString();
      }
    }
    if(totalDebt!=null){
      if(totalDebt!=0){
        formattedTotalDebt = totalDebt!=null ? numFormat.format(totalDebt) : totalDebt.toString();
      }
    }
    if(currentDebt!=null){
      if(currentDebt!=0){
        formattedCurrentDebt = currentDebt!=null ? numFormat.format(currentDebt) : currentDebt.toString();
      }
    }

    if(json['balance']!=null){

      if(json['balance'].runtimeType is double){
        balance = json['balance'];
        formattedBalance = numFormat.format(balance);
      }else{
        if(json['balance']!=0){
          balance = double.parse(json['balance'].toString());
          formattedBalance = numFormat.format(balance);
        }
      }
    }
    daysLeftOfService = json['days_left_of_service'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['expired_debt'] = this.expiredDebt;
    data['total_debt'] = this.totalDebt;
    data['current_debt'] = this.currentDebt;
    data['balance'] = this.balance;
    data['days_left_of_service'] = this.daysLeftOfService;
    return data;
  }
}
