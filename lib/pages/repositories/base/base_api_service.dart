import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fine_taste/di/app_injector.dart';
import 'package:fine_taste/di/i_login_page.dart';
import 'package:fine_taste/manager/user_data_store/user_data_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/io_client.dart';

import '../../../helper/logger/logger.dart';
import '../../../model/base_response/request_error.dart';
import '../../../model/base_response/request_response.dart';
import '../end_point/end_point.dart';

enum RequestType { GET, POST, DELETE, PATCH, PUT }

abstract class ContentType {
  static const String json = 'application/json';
  static const String multipart = 'multipart/form-data';

  static const String formUrlEncoded = 'application/x-www-form-urlencoded';
}

abstract class BaseAPIService {
  final client = IOClient(HttpClient()
    ..badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true));

  Future<RequestResponse<dynamic>> make(RequestType type, EndPoint endpoint,
      {dynamic body,
        Map<String, dynamic>? headers,
        Map<String, dynamic>? params,
        String contentType = ContentType.json}) {
   // printLog("body", body);
    dynamic jsonBody;

    if (body != null && contentType == ContentType.json) {
      jsonBody = json.encode(body);
    } else {
      jsonBody = body;
    }

    printLog('Request body', jsonBody.toString());



    Uri uri;

    if (params != null && params.isNotEmpty) {
      params.removeWhere((key, value) => value == "null");
      uri = Uri.https(endpoint.base, endpoint.path, Map.from(params));
    } else {
      uri = Uri.https(endpoint.base, endpoint.path);
    }

    printLog('Request URI', uri.toString());
    printLog('Request type', type.toString());

    Map allHeaders = {HttpHeaders.contentTypeHeader: contentType};

    if (headers != null) {
      allHeaders.addAll(headers);
    }

    printLog('Request Headers', allHeaders.toString());

    debugPrint(allHeaders.toString(), wrapWidth: 1024);

    Future result;

    switch (type) {
      case RequestType.GET:
        result = client.get(uri, headers: Map.from(allHeaders));
        break;
      case RequestType.DELETE:
        result = client.delete(uri, headers: Map.from(allHeaders));
        break;
      case RequestType.POST:
        result =
            client.post(uri, headers: Map.from(allHeaders), body: jsonBody);
        break;
      case RequestType.PATCH:
        result =
            client.patch(uri, headers: Map.from(allHeaders), body: jsonBody);
        break;
      case RequestType.PUT:
        result = client.put(uri, headers: Map.from(allHeaders), body: jsonBody);
        break;
    }

    return result.then((value) {
      if(value!=null){
        final decoded = json.decode(utf8.decode(value.bodyBytes));
        printLog("response", decoded);

        if (value.statusCode >= 200 && value.statusCode < 300) {
          return RequestResponse(data: decoded);
        } else if(value.statusCode==401){
          showSessionExpireAlert();
          return RequestResponse(error: RequestError(statusCode: value.statusCode, data: decoded));

        }else {
          // printLog(" error response", decoded);
          return RequestResponse(error: RequestError(statusCode: value.statusCode, data: decoded));
        }
      }else return RequestResponse(
          error: RequestError(statusCode: value.statusCode, data: null));

    });
  }

  Future<RequestResponse<dynamic>> makeDio(RequestType type, EndPoint endpoint,
      {dynamic body,
        Map<String, dynamic>? headers,
        Map<String, dynamic>? params,
        String contentType = ContentType.json}){

    Uri uri;
    if (params != null && params.isNotEmpty) {
      params.removeWhere((key, value) => value == "null");
      uri = Uri.https(endpoint.base, endpoint.path, Map.from(params));
    } else {
      uri = Uri.https(endpoint.base, endpoint.path);
    }
    printLog("Base url", uri.toString());
    return  Dio().post(uri.toString(),data: body,options: Options(contentType: 'multipart/form-data',
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        })).then((value) {
          printLog("Response Data", value);
      if (value.data != null) {

        return RequestResponse(data: value.data);

      } else {
        return RequestResponse(error: value.data);

      }
    });



  }
  showSessionExpireAlert() {
    Get.defaultDialog(
        title: '',
        titleStyle: TextStyle(fontSize: 1),
        middleText: '',
        barrierDismissible: false,
        confirmTextColor: Colors.white,
        content: MediaQuery(
          data: MediaQuery.of(Get.context!).copyWith(textScaleFactor: 1.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Session is expired! Please login again",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold))
            ],
          ),
        ),
        textConfirm: 'Login',
        onConfirm: ()  async {
          await AppInjector.instance.userDataStore.deleteUser();
          Navigator.of(Get.overlayContext!, rootNavigator: true).pop();
          Get.offAll(AppInjector.instance.loginPage);


        });
  }
}