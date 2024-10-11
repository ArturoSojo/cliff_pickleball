import 'package:optional/optional.dart';
import '../../../utils/translate.dart';

class ListModel{
  String? PREPAY;
  String? formattedPrepay;
  String? POSTPAID;
  String? formattedPostpaid;
  ListModel({this.PREPAY, this.formattedPrepay, this.POSTPAID, this.formattedPostpaid});

  ListModel.fromList(List<String> list){
    PREPAY = list.where((x) => x == "PREPAY").firstOptional.orElseNull;
    if(PREPAY!=null){
      formattedPrepay = translate(PREPAY ?? "");
    }
    POSTPAID = list.where((x) => x == "POSTPAID").firstOptional.orElseNull;
    if(POSTPAID!=null){
      formattedPostpaid = translate(POSTPAID ?? "");
    }
  }

  toList(){
    return <String>[
      PREPAY ?? "",
      POSTPAID ?? "",
    ];
  }
}