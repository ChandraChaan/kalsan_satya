import 'package:json_annotation/json_annotation.dart';
part 'order_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class OrderResponse{

  int? status;
  String? message;
  List<Order>? orders;
  OrderResponse(this.status, this.message, this.orders);

  factory OrderResponse.fromJson(Map<String,dynamic> json) => _$OrderResponseFromJson(json);

}
@JsonSerializable(fieldRename: FieldRename.snake)
class Order {
  String? id;
  String? orderId;
  String? deliveryBoy;
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
  List<Order>? items;
  List<Order>? returns;
  String? productId;
  String? quantity;
  String? unitPrice;
  String? totalPrice;
  String? productName;
  String?  storeName;
  Order(
      this.id,
      this.orderId,
      this.deliveryBoy,
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
      this.items,
      this.returns,
      this.productId,
      this.quantity,
      this.unitPrice,
      this.totalPrice,this.productName,this.storeName);



  factory Order.fromJson(Map<String,dynamic> json) => _$OrderFromJson(json);


}