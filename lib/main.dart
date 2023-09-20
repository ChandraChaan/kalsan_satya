import 'dart:async';
import 'dart:ui';

import 'package:fine_taste/common/utilities/ps_colors.dart';
import 'package:fine_taste/di/service.dart';
import 'package:fine_taste/pages/notifications/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'di/app_injector.dart';
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await initMethodChannel();

  await Firebase.initializeApp();

  // await initializeService();

  LocalNotificationService.initialize();

  FirebaseMessaging.onBackgroundMessage(fireBaseMessagingBackGroundHandler);

  // final permissionStatus = await Permission.location.request();
  // if (permissionStatus != PermissionStatus.granted) {
  //   print(permissionStatus);
  // }

  runApp(MaterialApp(
    home: AppInjector.instance.app,
    builder: EasyLoading.init(),
  ));
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: PSColors.app_color, // status bar color
  ));

  // LocationService.java.startLocationService();

  // Timer.periodic(const Duration(seconds: 5), (Timer timer) async {
  //   FlutterBackgroundService().invoke("setAsForeground");
  // });
}

const platform = MethodChannel('location_service');

Future<void> initMethodChannel() async {
  try {
    await platform.invokeMethod('startBackgroundService');
  } on PlatformException catch (e) {
    print('Failed to start background service: ${e.message}');
  }
}

Future fireBaseMessagingBackGroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

// Future<void> initializeService() async {
//   // final service = FlutterBackgroundService();
//
//   // /// OPTIONAL, using custom notification channel id
//   // const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   //   'my_foreground', // id
//   //   'MY FOREGROUND SERVICE', // title
//   //   description:
//   //       'This channel is used for important notifications.', // description
//   //   importance: Importance.low, // importance must be at low or higher level
//   // );
//   //
//   // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   //     FlutterLocalNotificationsPlugin();
//   //
//   // if (Platform.isIOS || Platform.isAndroid) {
//   //   await flutterLocalNotificationsPlugin.initialize(
//   //     const InitializationSettings(
//   //       iOS: DarwinInitializationSettings(),
//   //       android: AndroidInitializationSettings('ic_bg_service_small'),
//   //     ),
//   //   );
//   // }
//   //
//   // await flutterLocalNotificationsPlugin
//   //     .resolvePlatformSpecificImplementation<
//   //         AndroidFlutterLocalNotificationsPlugin>()
//   //     ?.createNotificationChannel(channel);
//
//   await service.configure(
//       androidConfiguration: AndroidConfiguration(
//         onStart: onStart,
//         autoStart: true,
//         isForegroundMode: true,
//       ),
//       iosConfiguration: IosConfiguration(onForeground: onStart));
//   service.startService();
// }

// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   DartPluginRegistrant.ensureInitialized();
//   // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   //     FlutterLocalNotificationsPlugin();
//
//   // if (service is AndroidServiceInstance) {
//   //   service.on('setAsForeground').listen((event) {
//   //     Timer.periodic(const Duration(seconds: 5), (timer) async {
//   //       Position position = await Geolocator.getCurrentPosition(
//   //           desiredAccuracy: LocationAccuracy.high);
//   //       makePostApiCall(position);
//   //       print('FLUTTER APP FOREGROUND');
//   //
//   //       /// OPTIONAL for use custom notification
//   //       /// the notification id must be equals with AndroidConfiguration when you call configure() method.
//   //       // flutterLocalNotificationsPlugin.show(
//   //       //   888,
//   //       //   'COOL SERVICE',
//   //       //   'Awesome ${DateTime.now()}',
//   //       //   const NotificationDetails(
//   //       //     android: AndroidNotificationDetails(
//   //       //       'my_foreground',
//   //       //       'MY FOREGROUND SERVICE',
//   //       //       icon: 'ic_bg_service_small',
//   //       //       ongoing: true,
//   //       //     ),
//   //       //   ),
//   //       // );
//   //
//   //       // if you don't using custom notification, uncomment this
//   //       // service.setForegroundNotificationInfo(
//   //       //   title: "My App Service",
//   //       //   content: "Updated at ${DateTime.now()}",
//   //       // );
//   //     });
//   //     service.setAsForegroundService();
//   //   });
//   //
//   //   service.on('setAsBackground').listen((event) {
//   //     Timer.periodic(const Duration(seconds: 5), (timer) async {
//   //       Position position = await Geolocator.getCurrentPosition(
//   //           desiredAccuracy: LocationAccuracy.high);
//   //       makePostApiCall(position);
//   //       print('FLUTTER APP BACKGROUND');
//   //
//   //       // /// OPTIONAL for use custom notification
//   //       // /// the notification id must be equals with AndroidConfiguration when you call configure() method.
//   //       // flutterLocalNotificationsPlugin.show(
//   //       //   888,
//   //       //   'COOL SERVICE',
//   //       //   'Awesome ${DateTime.now()}',
//   //       //   const NotificationDetails(
//   //       //     android: AndroidNotificationDetails(
//   //       //       'my_foreground',
//   //       //       'MY FOREGROUND SERVICE',
//   //       //       icon: 'ic_bg_service_small',
//   //       //       ongoing: true,
//   //       //     ),
//   //       //   ),
//   //       // );
//   //       //
//   //       // // if you don't using custom notification, uncomment this
//   //       // service.setForegroundNotificationInfo(
//   //       //   title: "My App Service",
//   //       //   content: "Updated at ${DateTime.now()}",
//   //       // );
//   //
//   //       print('FLUTTER APP BACKGROUND');
//   //     });
//   //     service.setAsBackgroundService();
//   //   });
//   //
//   //   // bring to foreground
//   //   // Timer.periodic(const Duration(seconds: 5), (timer) async {
//   //   //   if (await service.isForegroundService()) {
//   //   //     bool serviceEnabled;
//   //   //     LocationPermission permission;
//   //   //     // final locationModel = Provider.of<LocationModel>(navigatorKey.currentContext!, listen: false);
//   //   //     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   //   //     if (!serviceEnabled) {
//   //   //       return Future.error('Location services are disabled.');
//   //   //     }
//   //   //     permission = await Geolocator.checkPermission();
//   //   //     if (permission == LocationPermission.denied) {
//   //   //       permission = await Geolocator.requestPermission();
//   //   //       if (permission == LocationPermission.denied) {
//   //   //         return Future.error('Location permissions are denied');
//   //   //       }
//   //   //     }
//   //   //     if (permission == LocationPermission.deniedForever) {
//   //   //       return Future.error(
//   //   //           'Location permissions are permanently denied, we cannot request permissions.');
//   //   //     }
//   //   //     if (serviceEnabled && permission == LocationPermission.whileInUse) {
//   //   //       Position position = await Geolocator.getCurrentPosition(
//   //   //           desiredAccuracy: LocationAccuracy.high);
//   //   //       List<Placemark> placemarks = await placemarkFromCoordinates(
//   //   //           position.latitude, position.longitude);
//   //   //       if (placemarks != null && placemarks.isNotEmpty) {
//   //   //         Placemark placemark = placemarks[0];
//   //   //         makePostApiCall(position);
//   //   //
//   //   //         // flutterLocalNotificationsPlugin.show(
//   //   //         //   888,
//   //   //         //   'kalsan',
//   //   //         //   'User lat ${position.latitude} and long  ${position.longitude}',
//   //   //         //   const NotificationDetails(
//   //   //         //     android: AndroidNotificationDetails(
//   //   //         //       'my_foreground',
//   //   //         //       'MY FOREGROUND SERVICE',
//   //   //         //       icon: 'ic_bg_service_small',
//   //   //         //       ongoing: true,
//   //   //         //     ),
//   //   //         //   ),
//   //   //         // );
//   //   //         service.setForegroundNotificationInfo(
//   //   //           title: "kalsan",
//   //   //           content:
//   //   //               "User lat ${position.latitude} and long  ${position.longitude} ${placemark.street}",
//   //   //         );
//   //   //       }
//   //   //     }
//   //   //   }
//   //   // });
//   // }
// }

// Future<void> makePostApiCall(Position position) async {
//   try {
//     // Set up the API endpoint URL
//     Uri apiUrl =
//         Uri.parse('https://kalsanfood.com/kalsan_dev/api/send_location');
//
//     // Set up the request headers and body
//     final Map<String, String> headers = {
//       'Content-Type': 'application/json; charset=UTF-8',
//     };
//
//     Map<String, String> requestBody = {
//       "API_KEY": "640590",
//       "latitude": "${position?.latitude}",
//       "longitude": "${position?.longitude}",
//       "user_id": "21"
//     };
//
//     print("-------------------REQUEST BODY-----------------------");
//     print(requestBody.toString());
//     // Make the API call
//     http.Response response = await http.post(apiUrl,
//         headers: headers, body: json.encode(requestBody));
//     // Check the response status code
//     if (response.statusCode == 200) {
//       // API call succeeded, parse the response
//       String responseBody = response.body;
//       print("-------------------RESPONSE-----------------------");
//       print(responseBody);
//     } else {
//       // API call failed, handle the error
//       print('API call failed with status code: ${response.statusCode}');
//     }
//   } catch (e) {
//     // Error occurred during the API call
//     print('Error making API call: $e');
//   }
// }

// class BackgroundService {
//   //Get instance for flutter background service plugin
//   final FlutterBackgroundService flutterBackgroundService =
//       FlutterBackgroundService();
//
//   FlutterBackgroundService get instance => flutterBackgroundService;
//
//   Future<void> initializeService() async {
//     // await NotificationService(FlutterLocalNotificationsPlugin()).createChannel(
//     //     const AndroidNotificationChannel(
//     //         notificationChannelId, notificationChannelId));
//     await flutterBackgroundService.configure(
//       androidConfiguration: AndroidConfiguration(
//           // this will be executed when app is in foreground or background in separated isolate
//           onStart: onStart,
//           // auto start service
//           autoStart: false,
//           isForegroundMode: true),
//       //Currently IOS setup is not completed.
//       iosConfiguration: IosConfiguration(
//         // auto start service
//         autoStart: true,
//         // this will be executed when app is in foreground in separated isolate
//         onForeground: onStart,
//       ),
//     );
//     await flutterBackgroundService.startService();
//   }
//
//   void setServiceAsForeGround() async {
//     flutterBackgroundService.invoke("setAsForeground");
//   }
//
//   void stopService() {
//     flutterBackgroundService.invoke("stop_service");
//   }
// }
