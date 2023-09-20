import 'dart:convert';

import 'package:fine_taste/common/load_container/load_container.dart';
import 'package:fine_taste/common/utilities/fonts.dart';
import 'package:fine_taste/common/utilities/ps_colors.dart';
import 'package:fine_taste/di/i_home_page.dart';
import 'package:fine_taste/model/login/login_response.dart';
import 'package:fine_taste/model/store/last_invoice_response.dart';
import 'package:fine_taste/pages/home/widget/home_widget.dart';
import 'package:fine_taste/pages/repositories/end_point/end_point.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import '../../../app/arch/bloc_provider.dart';
import '../../../common/bottom_naviagationbar/bottom_bar.dart';
import '../../../di/app_injector.dart';
import '../bloc/home_page_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  HomePageBloc? _bloc;
  final Stream<RemoteMessage> _stream = FirebaseMessaging.onMessageOpenedApp;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _stream.listen((RemoteMessage event) async {
      if (event.data != null) {
        await Get.to(AppInjector.instance.notification);
      }
    });
  }

  double latitude = 17.3850;
  double longitude = 78.4867;

  Future<void> _getLocation() async {
    try {
      final LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        final Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        setState(() {
          latitude = position.latitude;
          longitude = position.longitude;
        });
        sendTimings();
      } else {
        setState(() {
          latitude = 0;
          longitude = 0;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        latitude = 0;
        longitude = 0;
      });
    }
  }

  bool clock_in = false;

  void sendTimings() async {
    EasyLoading.show(status: 'loading...');

    // Define the API endpoint URL
    var url = Uri.parse('https://kalsanfood.com/kalsan_dev/api/clockin_out');

    // Prepare the request body
    var body = {
      "API_KEY": "640590",
      "user_id": "27",
      "latitude": "$latitude",
      "longitude": "$longitude",
      "clock_in": clock_in ? DateTime.now().toString() : "",
      "clock_out": !clock_in ? DateTime.now().toString() : "",
    };

    // Make the POST request
    var response = await http.post(url, body: body);

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Parse the JSON response
      Map<String, dynamic> data = json.decode(response.body);
      // display
      print('apidata');
      print(body.toString());
      print(123);
      print(data.toString());
      clock_in = !clock_in;
      setState(() {});
      EasyLoading.dismiss();
      Get.snackbar('${data['message']}', '',
          colorText: Colors.white,
          backgroundColor: Color(0xFF0B8BCB),
          snackPosition: SnackPosition.BOTTOM);
    } else {
      EasyLoading.dismiss();
      // Handle errors here, such as network issues or server errors
      print(
          'Failed to make the API request. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return LoaderContainer(
      stream: _bloc!.isLoading,
      child: Scaffold(
        backgroundColor: PSColors.bg_color,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: PSColors.app_color,
          title: Text(
            'Home',
            style: TextStyle(
                color: PSColors.white_color,
                fontSize: 20,
                fontFamily: WorkSans.regular),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  _getLocation();
                },
                icon: Icon(
                  Icons.schedule,
                  color: clock_in ? Colors.green : Colors.white,
                ),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                StreamBuilder<UserInformation>(
                    initialData: null,
                    stream: _bloc!.user,
                    builder: (context, snapshot) {
                      return (snapshot.data != null)
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              height: 120,
                              margin: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: PSColors.yellow_color,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10),
                                    child: CircleAvatar(
                                      radius: 45,
                                      backgroundColor: Colors.white,
                                      child: ClipOval(
                                        child: SizedBox.fromSize(
                                          size: const Size.fromRadius(
                                              44), // Image radius
                                          child: (snapshot.data != null)
                                              ? Image.network(
                                                  EndPoints.base_url +
                                                      snapshot.data!.userImage!,
                                                  width: 44,
                                                  height: 44,
                                                  fit: BoxFit.fill,
                                                  errorBuilder: (BuildContext
                                                          context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                    return Image.asset(
                                                        'assets/images/splash_logo.png');
                                                  },
                                                )
                                              : Image.asset(
                                                  'assets/images/splash_logo.png'),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 25),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data!.userName!,
                                          style: TextStyle(
                                              fontFamily: WorkSans.semiBold,
                                              fontSize: 16,
                                              color: PSColors.text_black_color),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          snapshot.data!.email!,
                                          style: TextStyle(
                                              fontFamily: WorkSans.regular,
                                              fontSize: 14,
                                              color: PSColors.text_black_color),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          snapshot.data!.mobileNo!,
                                          style: TextStyle(
                                              fontFamily: WorkSans.regular,
                                              fontSize: 14,
                                              color: PSColors.text_black_color),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          : const SizedBox();
                    }),
                StreamBuilder<LastInvoiceResponse>(
                    initialData: null,
                    stream: _bloc!.getCounts,
                    builder: (context, snapshot) {
                      return (snapshot.data != null)
                          ? HomeWidget(snapshot.data!)
                          : const SizedBox();
                    }),
                Container(
                  margin: const EdgeInsets.all(15),
                  height: 48,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: ElevatedButton.icon(
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: PSColors.white_color,
                        size: 18.0,
                      ),
                      label: Text(
                        'Create Order',
                        style: TextStyle(
                            fontSize: 14, color: PSColors.white_color),
                      ),
                      onPressed: () {
                        Get.to(AppInjector.instance.storeList(2));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: HexColor('#FFCB04'),
                        onPrimary: PSColors.text_black_color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ),
                StreamBuilder<LastInvoiceResponse>(
                    initialData: null,
                    stream: _bloc!.getCounts,
                    builder: (context, snapshot) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: (snapshot.data != null &&
                                snapshot.data!.opening_stock != null)
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      'Assigned Stock',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: WorkSans.regular,
                                          color: PSColors.white_color),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Wrap(
                                      children: snapshot.data!.opening_stock!
                                          .map((e) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: 108,
                                        height: 110,
                                        decoration: BoxDecoration(
                                            color: HexColor('#0B8BCB'),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(13.0),
                                          child: Center(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Center(
                                                  child: Text(
                                                    e.name ??
                                                        "".replaceAll(" ", ""),
                                                    style: TextStyle(
                                                      fontFamily:
                                                          WorkSans.regular,
                                                      fontSize: 16,
                                                      color:
                                                          PSColors.white_color,
                                                    ),
                                                  ),
                                                ),
                                                Center(
                                                  child: Text(
                                                    e.value.toString() ?? "",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            WorkSans.semiBold,
                                                        fontSize: 22,
                                                        color: PSColors
                                                            .white_color),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList())
                                ],
                              )
                            : const SizedBox(),
                      );
                    }),
                StreamBuilder<LastInvoiceResponse>(
                    initialData: null,
                    stream: _bloc!.getCounts,
                    builder: (context, snapshot) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: (snapshot.data != null &&
                                snapshot.data!.close_stock != null)
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      'Delivered Stock',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: WorkSans.regular,
                                          color: PSColors.white_color),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Wrap(
                                      children:
                                          snapshot.data!.close_stock!.map((e) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: 108,
                                        height: 110,
                                        decoration: BoxDecoration(
                                            color: HexColor('#0B8BCB'),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                e.name ?? "",
                                                style: TextStyle(
                                                  fontFamily: WorkSans.regular,
                                                  fontSize: 16,
                                                  color: PSColors.white_color,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                e.value.toString() ?? "",
                                                style: TextStyle(
                                                    fontFamily:
                                                        WorkSans.semiBold,
                                                    fontSize: 22,
                                                    color:
                                                        PSColors.white_color),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList())
                                ],
                              )
                            : const SizedBox(),
                      );
                    }),
                StreamBuilder<LastInvoiceResponse>(
                    initialData: null,
                    stream: _bloc!.getCounts,
                    builder: (context, snapshot) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: (snapshot.data != null &&
                                snapshot.data!.remaining_stock != null)
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      'Remaining Stock',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: WorkSans.regular,
                                          color: PSColors.white_color),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Wrap(
                                      children: snapshot.data!.remaining_stock!
                                          .map((e) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: 108,
                                        height: 110,
                                        decoration: BoxDecoration(
                                            color: HexColor('#0B8BCB'),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                e.name ?? "",
                                                style: TextStyle(
                                                  fontFamily: WorkSans.regular,
                                                  fontSize: 16,
                                                  color: PSColors.white_color,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                e.value.toString() ?? "",
                                                style: TextStyle(
                                                    fontFamily:
                                                        WorkSans.semiBold,
                                                    fontSize: 22,
                                                    color:
                                                        PSColors.white_color),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList())
                                ],
                              )
                            : const SizedBox(),
                      );
                    }),
                StreamBuilder<LastInvoiceResponse>(
                    initialData: null,
                    stream: _bloc!.getCounts,
                    builder: (context, snapshot) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: (snapshot.data != null &&
                                snapshot.data!.return_stock != null)
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      'Expired Stock',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: WorkSans.regular,
                                          color: PSColors.white_color),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Wrap(
                                      children:
                                          snapshot.data!.return_stock!.map((e) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: 108,
                                        height: 110,
                                        decoration: BoxDecoration(
                                            color: HexColor('#0B8BCB'),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                e.name ?? "",
                                                style: TextStyle(
                                                  fontFamily: WorkSans.regular,
                                                  fontSize: 16,
                                                  color: PSColors.white_color,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                e.value.toString() ?? "",
                                                style: TextStyle(
                                                    fontFamily:
                                                        WorkSans.semiBold,
                                                    fontSize: 22,
                                                    color:
                                                        PSColors.white_color),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList())
                                ],
                              )
                            : const SizedBox(),
                      );
                    })
              ],
            ),
          ),
        ),
        bottomNavigationBar: bottomBar(),
      ),
    );
  }
}
