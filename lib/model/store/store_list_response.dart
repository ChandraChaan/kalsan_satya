import 'package:json_annotation/json_annotation.dart';
part 'store_list_response.g.dart';


@JsonSerializable(fieldRename: FieldRename.snake)
class StoreListResponse{

  int? status;
  String? message;
  List<Store>? stores;
  StoreListResponse(this.status, this.message, this.stores);

  factory StoreListResponse.fromJson(Map<String,dynamic> json) => _$StoreListResponseFromJson(json);

}
@JsonSerializable(fieldRename: FieldRename.snake)
class Store {
  String? id;
  String? storeName;
  String? contactName;
  String? email;
  String? mobile;
  String? address;
  String? gstNumber;
  String? discountPercentage;
  String? status;
  String? isDeleted;
  String? createdDate;
  String? tax;
  String? image;
  Store(
      this.id,
      this.storeName,
      this.contactName,
      this.email,
      this.mobile,
      this.address,
      this.gstNumber,
      this.discountPercentage,
      this.status,
      this.isDeleted,
      this.createdDate,this.tax,this.image);

  factory Store.fromJson(Map<String,dynamic> json) => _$StoreFromJson(json);

}