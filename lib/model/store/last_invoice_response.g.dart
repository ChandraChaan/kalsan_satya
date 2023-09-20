// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'last_invoice_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LastInvoiceResponse _$LastInvoiceResponseFromJson(Map<String, dynamic> json) =>
    LastInvoiceResponse(
      json['status'] as int?,
      json['message'] as String?,
      (json['previous_balance'] as num?)?.toDouble(),
      json['counts'] == null
          ? null
          : LastInvoiceResponse.fromJson(
              json['counts'] as Map<String, dynamic>),
      json['total_orders'] as int?,
      json['today_orders'] as int?,
      json['deliver_orders'] as int?,
      json['stores_count'] as int?,
      (json['notifications'] as List<dynamic>?)
          ?.map((e) => LastInvoiceResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['id'] as String?,
      json['title'] as String?,
      json['text'] as String?,
      json['send_date'] as String?,
      (json['opening_stock'] as List<dynamic>?)
          ?.map((e) => Common.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['close_stock'] as List<dynamic>?)
          ?.map((e) => Common.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['remaining_stock'] as List<dynamic>?)
          ?.map((e) => Common.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['return_stock'] as List<dynamic>?)
          ?.map((e) => Common.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LastInvoiceResponseToJson(
        LastInvoiceResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'previous_balance': instance.previousBalance,
      'counts': instance.counts,
      'total_orders': instance.totalOrders,
      'today_orders': instance.todayOrders,
      'deliver_orders': instance.deliverOrders,
      'stores_count': instance.storesCount,
      'notifications': instance.notifications,
      'id': instance.id,
      'title': instance.title,
      'text': instance.text,
      'send_date': instance.sendDate,
      'opening_stock': instance.opening_stock,
      'close_stock': instance.close_stock,
      'remaining_stock': instance.remaining_stock,
      'return_stock': instance.return_stock,
    };

Common _$CommonFromJson(Map<String, dynamic> json) => Common(
      json['name'] as String?,
      json['value'] as int?,
    );

Map<String, dynamic> _$CommonToJson(Common instance) => <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
    };
