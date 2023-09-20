import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import '../../../manager/user_data_store/user_data_store.dart';
import '../../../model/base_response/request_error.dart';
import '../../../model/base_response/request_response.dart';
import '../end_point/end_point.dart';
import 'base_api_service.dart';



class RefreshableService extends BaseAPIService {
  final UserDataStore userDataStore;

  RefreshableService(this.userDataStore);

  Future<RequestResponse<dynamic>> makeRefreshable(
      RequestType type, EndPoint endpoint,
      {dynamic body,
        Map<String, dynamic>? headers,
        Map<String, dynamic>? params,String? contentType}) {

    return userDataStore.getUser().then((u) {
      if (u != null) {
        Map<String, dynamic> allHeaders = {
         // 'Authorization':  u.token!
        };

        if (headers != null && headers.isNotEmpty) {
          allHeaders.addAll(headers);
        }
        return (contentType!=ContentType.multipart)?make(type, endpoint, body: body, headers: allHeaders, params: params)
            .then((value) {
          if (value.data != null) {

            return RequestResponse(data: value.data);

          } else {
            var error = value.error;
            return RequestResponse(error: value.error);

          }
        }):Dio(BaseOptions( headers:allHeaders)).post('https://beta5.365hosting.in/M3_dev/services',data: body,options: Options(contentType: 'multipart/form-data',
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            })).then((value) {
          if (value.data != null) {

            return RequestResponse(data: value.data);

          } else {
            return RequestResponse(error: value.data);

          }
        });

      } else {
        return RequestResponse(error: RequestError.noUser());
      }
    });
  }





  logOut() async {


  }

  showSessionExpireAlert() {
    Get.defaultDialog(
        title: '',
        titleStyle: TextStyle(fontSize: 1),
        middleText: '',
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
        onConfirm: () async {
          Get.back();


        });
  }

}