import 'dart:async';

import 'package:fine_taste/app/arch/bloc_provider.dart';
import 'package:fine_taste/common/container_widget/container_widget.dart';
import 'package:fine_taste/common/load_container/load_container.dart';
import 'package:fine_taste/common/textfield/my_text_field.dart';
import 'package:fine_taste/common/utilities/ps_colors.dart';
import 'package:fine_taste/di/app_injector.dart';
import 'package:fine_taste/di/i_home_page.dart';
import 'package:fine_taste/di/i_login_page.dart';
import 'package:fine_taste/main.dart';
import 'package:fine_taste/pages/login/bloc/login_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:toast/toast.dart';

import '../../../common/label/item_label_text.dart';
import '../../../common/textfield/pyc_password_text_filed.dart';
import '../../../common/textfield/pyc_text_filed.dart';
import '../../../common/utilities/fonts.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  LoginPageBloc? _bloc;
  FocusNode _passwordFocus = FocusNode();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    // backgroundService = BackgroundService();
    _bloc = BlocProvider.of(context);
    getDeviceToken();
  }

  // @pragma('vm:entry-point')
  // @override
  // Future<void> didChangeDependencies() async {
  //   //Start the service automatically if it was activated before closing the application
  //   if (await backgroundService.instance.isRunning()) {
  //     await backgroundService.initializeService();
  //   }
  //   backgroundService.instance.on('setAsBackground').listen((event) async {
  //     if (event != null) {
  //       Timer.periodic(const Duration(seconds: 5), (timer) async {
  //         Position position = await Geolocator.getCurrentPosition(
  //             desiredAccuracy: LocationAccuracy.high);
  //         makePostApiCall(position);
  //         print('FLUTTER APP BACKGROUND');
  //       });
  //     }
  //   });
  //
  //   super.didChangeDependencies();
  // }



  Future<void> getDeviceToken() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      final token = await messaging.getToken();
      _bloc?.token.add(token.toString());
      print('Device Token: $token');
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return LoaderContainer(
      stream: _bloc!.isLoading,
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/login_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: WorkSans.medium),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  PYCTextField(
                    labelText: '',
                    hintText: 'Email',
                    inputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    onChange: _bloc!.email.add,
                    onSubmit: (_) => _passwordFocus.requestFocus(),
                    validationStream: _bloc!.emailValidation,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  PYCPasswordTextField(
                      labelText: '',
                      hintText: 'Password',
                      obscureText: true,
                      focusNode: _passwordFocus,
                      inputAction: TextInputAction.done,
                      onSubmit: (_) => _bloc!.login.add(null),
                      onChange: _bloc!.password.add,
                      iconStream: _bloc!.isVisible,
                      onPressed: (value) {
                        _bloc!.addIsVisible.add(value);
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: Colors.white,
                              size: 14,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            ItemLabelText(
                              text: 'Remember me',
                              style: TextStyle(
                                  color: PSColors.white_color,
                                  fontSize: 11,
                                  fontFamily: WorkSans.regular),
                            ),
                          ],
                        ),
                        GestureDetector(
                            onTap: () {
                              Get.to(AppInjector.instance.forgot);
                            },
                            child: ItemLabelText(
                              text: 'Forgot Password ?',
                              style: TextStyle(
                                  color: PSColors.white_color,
                                  fontSize: 11,
                                  fontFamily: WorkSans.regular),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.10,
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: SizedBox(
                      height: 40,
                      width: 130,
                      child: ElevatedButton.icon(
                        icon: Icon(
                          Icons.arrow_back,
                          color: PSColors.text_black_color,
                          size: 16.0,
                        ),
                        label: Text(
                          'Log in',
                          style: TextStyle(
                              fontSize: 14, color: PSColors.text_black_color),
                        ),
                        onPressed: () {
                          // FlutterBackgroundService().invoke("setAsBackground");
                          _bloc!.login.add(null);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: HexColor('#FFCB04'),
                          onPrimary: PSColors.text_black_color,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
