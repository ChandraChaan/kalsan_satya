// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductsResponse _$ProductsResponseFromJson(Map<String, dynamic> json) =>
    ProductsResponse(
      json['status'] as int?,
      json['message'] as String?,
      (json['products'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['qr_code'] as String,
      BankDetails.fromJson(json['bank_details'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductsResponseToJson(ProductsResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'products': instance.products,
      'qr_code': instance.qrCode,
      'bank_details': instance.bankDetails,
    };

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      json['id'] as String?,
      json['product_name'] as String?,
      json['image'] as String?,
      json['price'] as String?,
      json['status'] as String?,
      json['qty'] as int?,
      (json['total'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'product_name': instance.productName,
      'image': instance.image,
      'price': instance.price,
      'status': instance.status,
      'qty': instance.qty,
      'total': instance.total,
    };

BankDetails _$BankDetailsFromJson(Map<String, dynamic> json) => BankDetails(
      json['id'] as String?,
      json['bank_name'] as String?,
      json['account_number'] as String?,
      json['branch'] as String?,
      json['ifsc_code'] as String?,
    );

Map<String, dynamic> _$BankDetailsToJson(BankDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bank_name': instance.bankName,
      'account_number': instance.accountNumber,
      'branch': instance.branch,
      'ifsc_code': instance.ifscCode,
    };
