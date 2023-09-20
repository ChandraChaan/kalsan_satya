// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreListResponse _$StoreListResponseFromJson(Map<String, dynamic> json) =>
    StoreListResponse(
      json['status'] as int?,
      json['message'] as String?,
      (json['stores'] as List<dynamic>?)
          ?.map((e) => Store.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StoreListResponseToJson(StoreListResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'stores': instance.stores,
    };

Store _$StoreFromJson(Map<String, dynamic> json) => Store(
      json['id'] as String?,
      json['store_name'] as String?,
      json['contact_name'] as String?,
      json['email'] as String?,
      json['mobile'] as String?,
      json['address'] as String?,
      json['gst_number'] as String?,
      json['discount_percentage'] as String?,
      json['status'] as String?,
      json['is_deleted'] as String?,
      json['created_date'] as String?,
      json['tax'] as String?,
      json['image'] as String?,
    );

Map<String, dynamic> _$StoreToJson(Store instance) => <String, dynamic>{
      'id': instance.id,
      'store_name': instance.storeName,
      'contact_name': instance.contactName,
      'email': instance.email,
      'mobile': instance.mobile,
      'address': instance.address,
      'gst_number': instance.gstNumber,
      'discount_percentage': instance.discountPercentage,
      'status': instance.status,
      'is_deleted': instance.isDeleted,
      'created_date': instance.createdDate,
      'tax': instance.tax,
      'image': instance.image,
    };
