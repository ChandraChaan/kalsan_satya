import 'package:json_annotation/json_annotation.dart';
part 'order_details_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class OrderDetailsResponse{
  int? status;
  String? message;
  OrderDetail? orderDetails;
  OrderDetailsResponse(this.status, this.message, this.orderDetails);

  factory OrderDetailsResponse.fromJson(Map<String,dynamic> json) => _$OrderDetailsResponseFromJson(json);


}
@JsonSerializable(fieldRename: FieldRename.snake)
class OrderDetail {

  String? id;
  String? orderId;

  OrderDetail(
      this.id,
      this.orderId,
      this.deliverBoy,
      this.storeId,
      this.gstAmount,
      this.previousBalance,
      this.invoiceAmount,
      this.paidAmount,
      this.payMethod,
      this.remarks,
      this.orderDate,
      this.isDeliver,
      this.deliveryDate,
      this.storeDetails,
      this.storeName,
      this.address,
      this.mobile,
      this.contactName,
      this.email,
      this.items,
      this.productId,
      this.quantity,
      this.unitPrice,
      this.totalPrice,
      this.productName,
      this.returns,
      this.balanceAmount);

  String? deliverBoy;
  String? storeId;
  String? gstAmount;
  String? previousBalance;
  String? invoiceAmount;
  String? paidAmount;
  String? payMethod;
  String? remarks;
  String? orderDate;
  String? isDeliver;
  String? deliveryDate;
  OrderDetail? storeDetails;
  String? storeName;
  String? address;
  String? mobile;
  String? contactName;
  String? email;
  List<OrderDetail>? items;
  String? productId;
  String? quantity;
  String? unitPrice;
  String? totalPrice;
  String? productName;
  List<OrderDetail>? returns;
  String? balanceAmount;

  factory OrderDetail.fromJson(Map<String,dynamic> json) => _$OrderDetailFromJson(json);


}