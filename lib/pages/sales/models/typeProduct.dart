import '../../../services/http/domain/productModel.dart';
import "package:logger/logger.dart";

final _logger = Logger();

class TypeProduct{
  List<ProductModel>? prepay;
  List<ProductModel>? pospay;
  TypeProduct({this.prepay, this.pospay});

  TypeProduct.fromJson(List<ProductModel> products){
    if(products.length!=0){

      products.forEach((ProductModel product){
        if(product.category?.trim() == "RECARGA"){
          prepay = [];
          prepay?.add(product);
        }
        if(product.category?.trim() == "POSPAGO"){
          pospay = [];
          pospay?.add(product);
        }
      });
    }
  }
  toJson(){
    Map<String, dynamic> json = {};
    json["prepay"] = prepay?.map((e) => e.toJson()).toList();
    json["pospay"] = pospay?.map((e) => e.toJson()).toList();
    return json;
  }
}