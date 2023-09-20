
import 'dart:io';
import 'package:fine_taste/app/arch/bloc_provider.dart';
import 'package:fine_taste/di/i_login_page.dart';
import 'package:fine_taste/helper/logger/logger.dart';
import 'package:fine_taste/manager/user_data_store/user_data_store.dart';
import 'package:fine_taste/model/store/last_invoice_response.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import '../../../common/bottom_sheet/file_upload_bottom_sheet.dart';
import '../../../common/toast/toast.dart';
import '../../../common/validators/validators.dart';
import '../../../di/app_injector.dart';
import '../../../model/base_response/request_response.dart';
import '../../../model/login/login_response.dart';
import '../../repositories/login/login_api.dart';

typedef BlocProvider<NotificationBloc> NotificationFactory();

class NotificationBloc extends BlocBase{
  LoginService? loginService;
  UserDataStore? userDataStore;
  BehaviorSubject<bool> _isLoading =BehaviorSubject.seeded(false);
  BehaviorSubject<bool> _valid =BehaviorSubject.seeded(false);
  BehaviorSubject<List<LastInvoiceResponse>> _notifications =BehaviorSubject.seeded([]);
  Stream<List<LastInvoiceResponse>> get notifications => _notifications;
  Stream<bool> get isLoading=> _isLoading;

  NotificationBloc(this.loginService,this.userDataStore){
    setListeners();
  }


  void setListeners() async{
    UserInformation? userInformation=await  userDataStore?.getUser();
    _isLoading.add(true);
    loginService!.getNotifications({'API_KEY':'640590'}).then((value){
      _isLoading.add(false);
      if(value.data!=null){
        if(value.data!.status==1){
          if(value.data!.notifications!=null){
             _notifications.add(value.data!.notifications!);

          }else ToastMessage(value.data!.message!);
        }else ToastMessage(value.data!.message!);

      }else ToastMessage('Invalid Response');
    });

  }

}