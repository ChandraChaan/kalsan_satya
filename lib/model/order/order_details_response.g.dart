// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDetailsResponse _$OrderDetailsResponseFromJson(
        Map<String, dynamic> json) =>
    OrderDetailsResponse(
      json['status'] as int?,
      json['message'] as String?,
      json['order_details'] == null
          ? null
          : OrderDetail.fromJson(json['order_details'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderDetailsResponseToJson(
        OrderDetailsResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'order_details': instance.orderDetails,
    };

OrderDetail _$OrderDetailFromJson(Map<String, dynamic> json) => OrderDetail(
      json['id'] as String?,
      json['order_id'] as String?,
      json['deliver_boy'] as String?,
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
      json['store_details'] == null
          ? null
          : OrderDetail.fromJson(json['store_details'] as Map<String, dynamic>),
      json['store_name'] as String?,
      json['address'] as String?,
      json['mobile'] as String?,
      json['contact_name'] as String?,
      json['email'] as String?,
      (json['items'] as List<dynamic>?)
          ?.map((e) => OrderDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['product_id'] as String?,
      json['quantity'] as String?,
      json['unit_price'] as String?,
      json['total_price'] as String?,
      json['product_name'] as String?,
      (json['returns'] as List<dynamic>?)
          ?.map((e) => OrderDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['balance_amount'] as String?,
    );

Map<String, dynamic> _$OrderDetailToJson(OrderDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_id': instance.orderId,
      'deliver_boy': instance.deliverBoy,
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
      'store_details': instance.storeDetails,
      'store_name': instance.storeName,
      'address': instance.address,
      'mobile': instance.mobile,
      'contact_name': instance.contactName,
      'email': instance.email,
      'items': instance.items,
      'product_id': instance.productId,
      'quantity': instance.quantity,
      'unit_price': instance.unitPrice,
      'total_price': instance.totalPrice,
      'product_name': instance.productName,
      'returns': instance.returns,
      'balance_amount': instance.balanceAmount,
    };
