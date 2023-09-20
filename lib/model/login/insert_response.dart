import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
part 'insert_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class InsertResponse {
   final int? status;
   final String? message;

  InsertResponse({this.status , this.message});
   factory InsertResponse.fromJson(Map<String,dynamic> json) => _$InsertResponseFromJson(json);


}
