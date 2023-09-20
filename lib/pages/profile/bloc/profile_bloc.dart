
import 'dart:io';
import 'package:fine_taste/app/arch/bloc_provider.dart';
import 'package:fine_taste/di/i_login_page.dart';
import 'package:fine_taste/helper/logger/logger.dart';
import 'package:fine_taste/manager/user_data_store/user_data_store.dart';
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

typedef BlocProvider<ProfilePageBloc> ProfilePageFactory();

class ProfilePageBloc extends BlocBase{
  LoginService? loginService;
  UserDataStore? userDataStore;
  BehaviorSubject<bool> _isLoading =BehaviorSubject.seeded(false);
  BehaviorSubject<bool> _valid =BehaviorSubject.seeded(false);
  BehaviorSubject<UserInformation> _user=BehaviorSubject();
  BehaviorSubject<String> _name=BehaviorSubject.seeded('');
  BehaviorSubject<String> _email=BehaviorSubject.seeded('');
  BehaviorSubject<String> _mobil=BehaviorSubject.seeded('');
  BehaviorSubject<String> _emailValidation = BehaviorSubject.seeded('');
  BehaviorSubject<String> _phoneValidation = BehaviorSubject.seeded('');
  BehaviorSubject<File> _profileFile=BehaviorSubject();
  PublishSubject<void> _save = PublishSubject();
  PublishSubject<Future<FormData>> _submitProfile=PublishSubject();
  Sink<void> get save => _save;
  Stream<File> get profileFile => _profileFile;
  Stream<String?> get emailValidation => _emailValidation;
  Stream<String?> get phoneValidation => _phoneValidation;
  Sink<String> get name => _name;
  Sink<String> get email => _email;
  Sink<String> get mobil => _mobil;
  Stream<UserInformation> get user => _user;
  Stream<bool> get  valid=> _valid;
  Stream<bool> get isLoading=> _isLoading;
   FormValidator? _validator;
  File? imageFile;
  ProfilePageBloc(this._validator,this.loginService,this.userDataStore){
    _getUser();
    setListeners();
  }

  void _getUser() async{

    UserInformation? userInformation=await  userDataStore?.getUser();

    _name.add(userInformation!.userName!);
    _email.add(userInformation.email!);
    _mobil.add(userInformation.mobileNo!);
    _user.add(userInformation);

  }
  void deleteUser() async{
    showDialog(
        context: Get.context!,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure do you want to logout?'),
            actions: [
              // The "Yes" button
              TextButton(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    await  userDataStore?.deleteUser();
                    Get.offAll(AppInjector.instance.loginPage);

                  },
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                  child: const Text('No'))
            ],
          );
        });


  }

  void setListeners() async{
    UserInformation? userInformation=await  userDataStore?.getUser();
    _email
        .map((e) => e.toLowerCase())
        .map(_validator!.validateEmail)
        .listen((event) {
          printLog("msg", event);
      if(event!=null)
        _emailValidation.add(event);
      else _emailValidation.add("");
    },).addTo(disposeBag);

    _mobil.map((e) => e.toLowerCase()).map(_validator!.validatePhone)
        .listen((event) {
      printLog("msg", event);
      if(event!=null)
        _phoneValidation.add(event);
      else _phoneValidation.add("");
    },).addTo(disposeBag);


    CombineLatestStream.combine3(_emailValidation, _phoneValidation,_name,
            (String a, String b,String c) => a=="" && b==''&&c.isNotEmpty)
        .listen(_valid.add)
        .addTo(disposeBag);

    _save
        .withLatestFrom(_valid, (_, bool v) {
      if(v!=true) ToastMessage('Enter Details');
      return v;
    })
        .where((event) => event)
        .withLatestFrom3(_email, _name,_mobil, (t, String a, String b,String c) async
      {  return FormData.fromMap((imageFile!=null)?{
      'API_KEY': '640590',
      'name': b,
      'email': a,
      'user_id': userInformation!.userId,
      'phone': c,
      'profile_pic': await MultipartFile.fromFile(imageFile!.path,filename: imageFile!.path.split('/').last)
    }:{
        'API_KEY': '640590',
        'name': b,
        'email': a,
        'user_id': userInformation!.userId,
        'phone': c,
    });
  }
    ).listen(_submitProfile.add)
        .addTo(disposeBag);

    _submitProfile.
    doOnData((_)=> _isLoading.add(true))
        .map(loginService!.updateProfile)
        .listen((event) {
      _handleAuthResponse(event);
    })
        .addTo(disposeBag);


  }
  selectImage(){
    FileUploadBottomSheet(onCallback: (file) async {
      Navigator.pop(Get.context!);
      if (file == 'Cam') {
        imageFile = await getImageFromCamera();
      } else {
        imageFile = await getImageFromGallery();
      }
      _profileFile.add(imageFile!);
      printLog("imageFile",imageFile);
    });
  }
  _handleAuthResponse(Future<RequestResponse<LoginResponse>> result) {
    result
        .asStream()
        .where((r) => r.error == null)
        .map((r) => r.data)
        .listen((u) async {
      _isLoading.add(false);
      if (u != null){
        if(u.status==1) {
          try{
            userDataStore!.insert(u.user_information!);
            _isLoading.add(true);
            await Future.delayed(const Duration(seconds: 6));
            _getUser();
            _isLoading.add(false);
            ToastMessage(u.message!);
          }catch(e){
            printLog("title", e.toString());
          }

        }else ToastMessage(u.message!);
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