// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insert_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InsertResponse _$InsertResponseFromJson(Map<String, dynamic> json) =>
    InsertResponse(
      status: json['status'] as int?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$InsertResponseToJson(InsertResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
    };
