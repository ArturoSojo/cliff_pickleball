import '../../store/models/collect_channel_model.dart';
import '../../store/models/store_model.dart';

class RechargeModel{
  List<CollectMethods>? banks;
  Results? product;

  RechargeModel({this.banks, this.product});

  RechargeModel.fromJson(List<Map<String, dynamic>> listBanks, Map<String, dynamic> mproduct){
    if(listBanks!=null){
      banks = [];
      listBanks.forEach((element) {
        banks?.add(CollectMethods.fromJson(element));
      });
    }
    if(mproduct!=null){
      product = Results.fromJson(mproduct);
    }
  }


}