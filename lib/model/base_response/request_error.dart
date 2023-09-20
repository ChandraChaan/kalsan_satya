
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import '../../helper/logger/logger.dart';

part 'request_error.g.dart';

@JsonSerializable(createToJson: false)
class FieldErrorModel {
  final String? field;
  final String? message;

  FieldErrorModel({this.field, this.message});

  factory FieldErrorModel.fromJson(Map<String, dynamic> json) =>
      _$FieldErrorModelFromJson(json);
}

class RequestError {
  final int? statusCode;

  String? _error;

  List<FieldErrorModel>? _errors;

  String? get error => _error;

  List<FieldErrorModel>? get errors => _errors;

  RequestError({this.statusCode, data}) {
    if (data != null){
      printLog("data", jsonEncode(data));

      if(jsonEncode(data).contains("errors")||jsonEncode(data).contains("detail")||jsonEncode(data).contains("match_format") ||jsonEncode(data).contains("error")){
        if(data['errors']!=null)
          _parseError(data);
        else if(data['detail']!=null){
          _error=data['detail'];

        }else if(data['match_format']!=null){
          _error=data['match_format'][0];
        } else if(data['error']!=null) {
          _error = data['error'];
        }
        else{
          //_error=data[0];
          _parseError(data);
        }
      }else {
        _error=data[0];
      }

    }
  }

  factory RequestError.singleMessage(String message) {

    final e = RequestError();
    e._error = message;
    printLog("message", e._error);
    return e;
  }

  factory RequestError.noUser() {
    return RequestError().._error = "No User";
  }

  factory RequestError.noToken() {
    return RequestError().._error = "Empty Token";
  }

  _parseError(Map d) {
    print(d);

    //_error = d['error'];
    if (d['errors'] != null) {
      _errors = List<FieldErrorModel>.from(d['errors'].map((e) => FieldErrorModel.fromJson(e)));
    }


  }
}