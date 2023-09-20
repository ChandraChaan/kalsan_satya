import 'package:json_annotation/json_annotation.dart';
part 'products_response.g.dart';


@JsonSerializable(fieldRename: FieldRename.snake)
class ProductsResponse{

  int? status;
  String? message;
  List<Product>? products;
  String qrCode;
  BankDetails bankDetails;

  ProductsResponse(this.status, this.message, this.products,this.qrCode,this.bankDetails);

  factory ProductsResponse.fromJson(Map<String,dynamic> json) => _$ProductsResponseFromJson(json);

}
@JsonSerializable(fieldRename: FieldRename.snake)
class Product {
 String? id;
 String? productName;
 String? image;
 String? price;
 String? status;
 int? qty;
 double? total;

 Product(this.id, this.productName, this.image, this.price, this.status,this.qty,this.total);

 factory Product.fromJson(Map<String,dynamic> json) => _$ProductFromJson(json);

}

@JsonSerializable(fieldRename: FieldRename.snake)
class BankDetails {
  String? id;
  String? bankName;
  String? accountNumber;
  String? branch;
  String? ifscCode;

  BankDetails(this.id, this.bankName, this.accountNumber, this.branch, this.ifscCode,);

  factory BankDetails.fromJson(Map<String,dynamic> json) => _$BankDetailsFromJson(json);

}