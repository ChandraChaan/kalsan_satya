import 'package:fine_taste/di/i_home_page.dart';
import 'package:fine_taste/di/i_login_page.dart';
import 'package:fine_taste/model/login/insert_response.dart';
import 'package:fine_taste/pages/repositories/login/login_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rxdart/rxdart.dart';
import '../../../app/arch/bloc_provider.dart';
import '../../../common/toast/toast.dart';
import '../../../common/validators/validators.dart';
import '../../../di/app_injector.dart';
import '../../../helper/logger/logger.dart';
import '../../../manager/user_data_store/user_data_store.dart';
import '../../../model/base_response/request_response.dart';
import '../../../model/login/login_response.dart';

typedef BlocProvider<ForgotBloc> ForgotFactory();

class ForgotBloc extends BlocBase {
  LoginService? loginService;
  UserDataStore? userDataStore;
  BehaviorSubject<String> _email = BehaviorSubject();
 
  PublishSubject<void> _login = PublishSubject();
  BehaviorSubject<String?> _emailValidation = BehaviorSubject<String>();
  BehaviorSubject<bool> _valid = BehaviorSubject<bool>.seeded(false);
 
  BehaviorSubject<bool> _isLoading =BehaviorSubject.seeded(false);
  PublishSubject<Map<String,dynamic>> _submitLogin=PublishSubject();
  Sink<String> get email => _email;
 
  Sink<void> get login => _login;
  Stream<String?> get emailValidation => _emailValidation;
  Stream<bool> get valid => _valid;


   late FormValidator _validator;
  Stream<bool> get isLoading=> _isLoading;

  ForgotBloc(this._validator,this.loginService,this.userDataStore){
    setListeners();
  }
  setListeners() {

    _email
        .map((e) => e.toLowerCase())
        .map(_validator.validateEmail)
        .listen((event) {
      if(event!=null)
        _emailValidation.add(event);
      else _emailValidation.add("");
    },)
        .addTo(disposeBag);
    CombineLatestStream.combine2(_emailValidation, _email,
            (a, String b) => a=="" && b.isNotEmpty)
        .listen(_valid.add)
        .addTo(disposeBag);

    _login
        .withLatestFrom(_valid, (_, bool v) {
      if(v!=true) ToastMessage('Enter Details');
      return v;
    })
        .where((event) => event)
        .withLatestFrom2(_email, _email, (t, String a, String b) => {
    "API_KEY":"640590", "email":a
    })
        .listen(_submitLogin.add)
        .addTo(disposeBag);

    _submitLogin.
    doOnData((_)=> _isLoading.add(true))
        .map(loginService!.forgot)
        .listen((event) {

      _handleAuthResponse(event);
    })
        .addTo(disposeBag);

  }
  _handleAuthResponse(Future<RequestResponse<InsertResponse>> result) {
    result
        .asStream()
        .where((r) => r.error == null)
        .map((r) => r.data)
        .listen((u) async {
      _isLoading.add(false);
      if (u != null){
        if(u.status==1) {
          showDialog(
              context: Get.context!,
              builder: (BuildContext ctx) {
                return AlertDialog(
                  content:  Text(u.message!),
                  actions: [
                    // The "Yes" button
                    TextButton(
                        onPressed: () async {
                          Navigator.pop(ctx);
                        Get.offAll(AppInjector.instance.loginPage);

                        },
                        child: const Text('Ok')),
                  ],
                );
              });
        }else ToastMessage('u.message!');
      }

    }).addTo(disposeBag);

    _handleError(result);
  }

  _handleError(Future<RequestResponse> result) {
    result
        .asStream()
        .where((r) => r.error != null)
        .map((r) => r.error)
        .doOnData((_) => _isLoading.add(false))
        .listen((e) {
      if (e != null){
        printLog("data", e.statusCode);
        //if(e.statusCode!=401)
      }
    }).addTo(disposeBag);


  }


}
