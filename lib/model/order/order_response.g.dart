// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderResponse _$OrderResponseFromJson(Map<String, dynamic> json) =>
    OrderResponse(
      json['status'] as int?,
      json['message'] as String?,
      (json['orders'] as List<dynamic>?)
          ?.map((e) => Order.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderResponseToJson(OrderResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'orders': instance.orders,
    };

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      json['id'] as String?,
      json['order_id'] as String?,
      json['delivery_boy'] as String?,
      json['store_id'] as String?,
      json['gst_amount'] as String?,
      json['previous_balance'] as String?,
      json['invoice_amount'] as String?,
      json['paid_amount'] as String?,
      json['pay_method'] as String?,
      json['remarks'] as String?,
      json['order_date'] as String?,
      json['is_deliver'] as String?,
      json['delivery_date'] as String?,
      (json['items'] as List<dynamic>?)
          ?.map((e) => Order.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['returns'] as List<dynamic>?)
          ?.map((e) => Order.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['product_id'] as String?,
      json['quantity'] as String?,
      json['unit_price'] as String?,
      json['total_price'] as String?,
      json['product_name'] as String?,
      json['store_name'] as String?,
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'order_id': instance.orderId,
      'delivery_boy': instance.deliveryBoy,
      'store_id': instance.storeId,
      'gst_amount': instance.gstAmount,
      'previous_balance': instance.previousBalance,
      'invoice_amount': instance.invoiceAmount,
      'paid_amount': instance.paidAmount,
      'pay_method': instance.payMethod,
      'remarks': instance.remarks,
      'order_date': instance.orderDate,
      'is_deliver': instance.isDeliver,
      'delivery_date': instance.deliveryDate,
      'items': instance.items,
      'returns': instance.returns,
      'product_id': instance.productId,
      'quantity': instance.quantity,
      'unit_price': instance.unitPrice,
      'total_price': instance.totalPrice,
      'product_name': instance.productName,
      'store_name': instance.storeName,
    };
