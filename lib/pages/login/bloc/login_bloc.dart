import 'dart:convert';
import 'dart:io';

import 'package:fine_taste/di/i_home_page.dart';
import 'package:fine_taste/pages/repositories/login/login_api.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
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
import 'package:http/http.dart' as http;

typedef BlocProvider<LoginPageBloc> LoginFactory();

class LoginPageBloc extends BlocBase {
  LoginService? loginService;
  UserDataStore? userDataStore;
  BehaviorSubject<String> _email = BehaviorSubject();
  BehaviorSubject<String> _password = BehaviorSubject();
  PublishSubject<void> _login = PublishSubject();
  BehaviorSubject<String?> _emailValidation = BehaviorSubject<String>();
  BehaviorSubject<bool> _valid = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> _isVisible = BehaviorSubject<bool>.seeded(true);
  BehaviorSubject<bool> _isLoading =BehaviorSubject.seeded(false);
  BehaviorSubject<String> _deviceToken =BehaviorSubject.seeded("");
  PublishSubject<Map<String,dynamic>> _submitLogin=PublishSubject();
  Sink<String> get email => _email;
  Sink<String> get password => _password;
  Sink<void> get login => _login;
  Stream<String?> get emailValidation => _emailValidation;
  Stream<bool> get valid => _valid;
  Sink<bool> get addIsVisible => _isVisible;
  Sink<bool> get isVisible => _isVisible;
  Sink<String> get  token=> _deviceToken;



  late FormValidator _validator;
  Stream<bool> get isLoading=> _isLoading;

  LoginPageBloc(this._validator,this.loginService,this.userDataStore){
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
    CombineLatestStream.combine2(_emailValidation, _password,
            (a, String b) => a=="" && b.isNotEmpty)
        .listen(_valid.add)
        .addTo(disposeBag);

    _login
        .withLatestFrom(_valid, (_, bool v) {
      if(v!=true) ToastMessage('Enter Details');
      return v;
    })
        .where((event) => event)
        .withLatestFrom3(_email, _password,_deviceToken, (t, String a, String b,String c) => {
    "API_KEY":"640590", "email":a, "password":b, 'device_name':(Platform.isAndroid)?'Android':'iOS','device_token':c
    }).listen(_submitLogin.add)
        .addTo(disposeBag);

    _submitLogin.
    doOnData((_)=> _isLoading.add(true))
        .map(loginService!.login)
        .listen((event) {

      _handleAuthResponse(event);
    })
        .addTo(disposeBag);

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
          userDataStore!.insert(u.user_information!);
          await Future.delayed(const Duration(seconds: 2));
          Get.to(AppInjector.instance.homePage);
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
      if (e != null) {
        printLog("data", e.statusCode);
        //if(e.statusCode!=401)
      }
    }).addTo(disposeBag);
  }

  Future getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    // final locationModel = Provider.of<LocationModel>(navigatorKey.currentContext!, listen: false);
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    if (serviceEnabled && permission == LocationPermission.whileInUse) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);
      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        makePostApiCall(position);
      }
    }
  }

  Future<void> makePostApiCall(Position position) async {
    try {
      // Set up the API endpoint URL
      Uri apiUrl =
      Uri.parse('https://kalsanfood.com/kalsan_dev/api/send_location');

      // Set up the request headers and body
      final Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      Map<String, String> requestBody = {
        "API_KEY": "640590",
        "latitude": "${position?.latitude}",
        "longitude": "${position?.longitude}",
        "user_id": "21"
      };

      // Make the API call
      http.Response response = await http.post(apiUrl,
          headers: headers, body: json.encode(requestBody));
      // Check the response status code
      if (response.statusCode == 200) {
        // API call succeeded, parse the response
        String responseBody = response.body;
        // Do something with the response data
        print(responseBody);
      } else {
        // API call failed, handle the error
        print('API call failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      // Error occurred during the API call
      print('Error making API call: $e');
    }
  }

}
