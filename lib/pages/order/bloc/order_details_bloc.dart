
import 'package:dio/dio.dart';
import 'package:fine_taste/app/arch/bloc_provider.dart';
import 'package:fine_taste/helper/logger/logger.dart';
import 'package:fine_taste/pages/repositories/end_point/end_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:io';
import '../../../manager/user_data_store/user_data_store.dart';
import '../../../model/order/order_details_response.dart';
import '../../../model/order/order_response.dart';
import '../../repositories/login/login_api.dart';
import '../widget/success_dialog.dart';
import 'package:permission_handler/permission_handler.dart';


typedef BlocProvider<OrderDetailsBloc> OrderDetailsFactory(Order? order);
class OrderDetailsBloc extends BlocBase {
  LoginService? loginService;
  UserDataStore? userDataStore;
  Order? order;
  BehaviorSubject<OrderDetail> _orderData = BehaviorSubject();
  BehaviorSubject<bool> _isLoading = BehaviorSubject.seeded(false);

  Stream<bool> get isLoading => _isLoading;

  Stream<OrderDetail> get orderData => _orderData;

  OrderDetailsBloc(this.userDataStore, this.loginService, this.order) {
    _setListener();
  }

  void _setListener() {
    _isLoading.add(true);
    loginService!.orderDetails(
        { "API_KEY": "640590", "order_id": order!.orderId}).then((value) {
      _isLoading.add(false);
      if (value.data != null) {
        printLog("response", value.data!);
        if (value.data!.status == 1) {
          _orderData.add(value.data!.orderDetails!);
        }
      }
    });
  }

  updateOrder() {
    _isLoading.add(true);
    loginService!.updateOrder(
        { "API_KEY": "640590", "order_id": order!.orderId}).then((value) {
      _isLoading.add(false);
      if (value.data != null) {
        printLog("response", value.data!);
        if (value.data!.status == 1) {
          SuccessDialog();
          _setListener();
        }
      }
    });
  }

  // downloadInvoiceFile(context) async {
  //   String downloadPath;
  //
  //   // _isLoading.add(true);
  //   //  bool isDisplay=false;
  //   var imageUrl = "${EndPoints
  //       .base_url}/api/invoice?API_KEY=640590&order_id=${order!.orderId}";
  //
  //   /// Using URL Launcher
  //   final Uri url = Uri.parse(imageUrl);
  //   if (url.hasAbsolutePath) {
  //     await launchUrl(
  //       url,
  //       mode: LaunchMode.externalApplication,
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("error")));
  //   }
  //   String fileName = imageUrl.substring(imageUrl.lastIndexOf("/") + 1);
  //   String savePath = await getFilePath(fileName);
  //    var dir = await DownloadsPathProvider.downloadsDirectory;
  //    if(dir != null) {
  //      String savename = "${order!.orderId}invoice.pdf";
  //      String savePath = dir.path + "/$savename";
  //      printLog("save path", savePath);
  //      await Dio().download(imageUrl, savePath, onReceiveProgress: (rec, total) {
  //        String progress = ((rec / total) * 100).toStringAsFixed(0);
  //        // printLog("progress", progress);
  //        if(progress=="100"){
  //
  //          _isLoading.add(false);
  //          if(!isDisplay){
  //            isDisplay=true;
  //            showDialog(
  //                context: Get.context!,
  //                builder: (BuildContext ctx) {
  //                  return AlertDialog(
  //                    content:  Text('Downloaded Successfully'),
  //                    actions: [
  //                      // The "Yes" button
  //                      TextButton(
  //                          onPressed: () async {
  //                            Navigator.pop(ctx);
  //                            isDisplay=false;
  //
  //                          },
  //                          child: const Text('Ok')),
  //                    ],
  //                  );
  //                });
  //          }
  //
  //        }
  //
  //      } );
  //    }
  //    var status = await Permission.storage.status;
  //    if (!status.isGranted) {
  //      status = await Permission.storage.request();
  //    }
  //   onLoading(context, true);
  //     try {
  //       if (Platform.isIOS) {
  //         downloadPath = (await getApplicationDocumentsDirectory()).path;
  //       } else {
  //         downloadPath = (await getExternalStorageDirectory())!.path;
  //       }
  //       final response = await FlutterDownloader.enqueue(
  //           url: imageUrl,
  //           savedDir: downloadPath,
  //           fileName: "Invoice",
  //           showNotification: true,
  //           openFileFromNotification: true,
  //         );
  //         if (response != null) {
  //           showToastWithBuildContext(
  //             context,
  //             const Icon(
  //               Icons.check,
  //               color: Colors.white,
  //             ),
  //             "Downloading of invoice started",
  //             Colors.green,
  //           );
  //           return true;
  //         }
  //
  //     } on DioError catch (e) {
  //       showToastWithBuildContext(
  //         context,
  //         const Icon(
  //           Icons.check,
  //           color: Colors.white,
  //         ),
  //         "Downloading of invoice failed",
  //         Colors.red,
  //       );
  //     } on Exception catch (e) {
  //       showToastWithBuildContext(
  //         context,
  //         const Icon(
  //           Icons.check,
  //           color: Colors.white,
  //         ),
  //         "Downloading of invoice failed",
  //         Colors.red,
  //       );
  //     }
  //
  //   }

  }

