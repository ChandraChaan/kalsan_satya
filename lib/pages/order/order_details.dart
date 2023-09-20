import 'dart:ui';

import 'package:fine_taste/app/arch/bloc_provider.dart';
import 'package:fine_taste/common/load_container/load_container.dart';
import 'package:fine_taste/common/utilities/convert_date_format.dart';
import 'package:fine_taste/model/order/order_details_response.dart';
import 'package:fine_taste/pages/order/widget/success_dialog.dart';
import 'package:fine_taste/pages/repositories/end_point/end_point.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/bottom_naviagationbar/bottom_bar.dart';
import '../../common/label/item_label_text.dart';
import '../../common/utilities/fonts.dart';
import '../../common/utilities/ps_colors.dart';
import 'bloc/order_details_bloc.dart';

class OrderDetails extends StatefulWidget {
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  OrderDetailsBloc? bloc;
  double? progress;
  String status = '';

  @override
  void initState() {
    bloc = BlocProvider.of(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PSColors.bg_color,
      appBar: AppBar(
          backgroundColor: PSColors.app_color,
          centerTitle: true,
          title: ItemLabelText(
              text: 'Order details',
              style: const TextStyle(
                  fontFamily: WorkSans.regular,
                  color: Colors.white,
                  fontSize: 18))),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          color: Colors.white,
          child: LoaderContainer(
            stream: bloc!.isLoading,
            child: SingleChildScrollView(
              child: StreamBuilder<OrderDetail>(
                  initialData: null,
                  stream: bloc!.orderData,
                  builder: (context, snapshot) {
                    return (snapshot.data != null)
                        ? Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                color: HexColor('#FFCB04'),
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    ItemLabelText(
                                      text: snapshot
                                          .data!.storeDetails!.storeName,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontFamily: WorkSans.semiBold),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ItemLabelText(
                                      text:
                                          '${snapshot.data!.storeDetails!.address} Ph : ${snapshot.data!.storeDetails!.mobile}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontFamily: WorkSans.regular),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 5,
                                            child: ItemLabelText(
                                              text:
                                                  'Order Id # ${snapshot.data!.orderId}',
                                              style: const TextStyle(
                                                  fontFamily: WorkSans.regular,
                                                  color: Colors.black,
                                                  fontSize: 14),
                                            )),
                                        Expanded(
                                            flex: 5,
                                            child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: ItemLabelText(
                                                  text:
                                                      'Date : ${ConvertDateFormat.customDate(snapshot.data!.orderDate!)}',
                                                  style: const TextStyle(
                                                      fontFamily:
                                                          WorkSans.regular,
                                                      color: Colors.black,
                                                      fontSize: 14),
                                                ))),
                                      ],
                                    ),
                                    const Divider(
                                      color: Colors.black,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: ItemLabelText(
                                          text: 'Details',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontFamily: WorkSans.semiBold,
                                              color: Colors.black)),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Center(
                                                child: ItemLabelText(
                                              text: 'S.no',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: WorkSans.semiBold,
                                                  color: Colors.black),
                                            ))),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                            flex: 3,
                                            child: ItemLabelText(
                                              text: 'Item Name',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: WorkSans.semiBold,
                                                  color: Colors.black),
                                            )),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: ItemLabelText(
                                              text: 'Qty',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: WorkSans.semiBold,
                                                  color: Colors.black),
                                            )),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: ItemLabelText(
                                              text: 'Price',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: WorkSans.semiBold,
                                                  color: Colors.black),
                                            )),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: ItemLabelText(
                                              text: 'Total Price',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: WorkSans.semiBold,
                                                  color: Colors.black),
                                            ))
                                      ],
                                    ),
                                    (snapshot.data!.items != null)
                                        ? (snapshot.data!.items!.length > 0)
                                            ? ListView.builder(
                                                itemCount: snapshot
                                                    .data!.items!.length,
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemBuilder: (b, s) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0,
                                                            bottom: 8.0),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            flex: 1,
                                                            child: Center(
                                                                child:
                                                                    ItemLabelText(
                                                              text: '${s + 1})',
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      WorkSans
                                                                          .regular,
                                                                  color: Colors
                                                                      .black),
                                                            ))),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Expanded(
                                                            flex: 3,
                                                            child:
                                                                ItemLabelText(
                                                              text: snapshot
                                                                  .data!
                                                                  .items![s]
                                                                  .productName,
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      WorkSans
                                                                          .regular,
                                                                  color: Colors
                                                                      .black),
                                                              textAlignment:
                                                                  TextAlign
                                                                      .start,
                                                            )),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Expanded(
                                                            flex: 2,
                                                            child:
                                                                ItemLabelText(
                                                              text: snapshot
                                                                  .data!
                                                                  .items![s]
                                                                  .quantity,
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      WorkSans
                                                                          .regular,
                                                                  color: Colors
                                                                      .black),
                                                            )),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: ItemLabelText(
                                                            text:
                                                                '₹ ${snapshot.data!.items![s].unitPrice}',
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    WorkSans
                                                                        .regular,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Expanded(
                                                            flex: 2,
                                                            child:
                                                                ItemLabelText(
                                                              text:
                                                                  '₹ ${double.parse(snapshot.data!.items![s].totalPrice!).toStringAsFixed(2)}',
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      WorkSans
                                                                          .regular,
                                                                  color: Colors
                                                                      .black),
                                                            ))
                                                      ],
                                                    ),
                                                  );
                                                })
                                            : const SizedBox()
                                        : const SizedBox(),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                              (snapshot.data!.returns != null)
                                  ? (snapshot.data!.returns!.length > 0)
                                      ? Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          color: HexColor('#AF4281'),
                                          padding: const EdgeInsets.only(
                                              top: 15, left: 15, bottom: 15),
                                          child: ItemLabelText(
                                            text: 'Returns / Expired',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontFamily: WorkSans.semiBold),
                                          ),
                                        )
                                      : const SizedBox()
                                  : const SizedBox(),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    (snapshot.data!.returns != null)
                                        ? (snapshot.data!.returns!.length > 0)
                                            ? Row(
                                                children: [
                                                  Expanded(
                                                      flex: 1,
                                                      child: Center(
                                                          child: ItemLabelText(
                                                        text: 'S.no',
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            fontFamily: WorkSans
                                                                .semiBold,
                                                            color:
                                                                Colors.black),
                                                      ))),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                      flex: 3,
                                                      child: ItemLabelText(
                                                        text: 'Item Name',
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            fontFamily: WorkSans
                                                                .semiBold,
                                                            color:
                                                                Colors.black),
                                                      )),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                      flex: 2,
                                                      child: ItemLabelText(
                                                        text: 'Qty',
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            fontFamily: WorkSans
                                                                .semiBold,
                                                            color:
                                                                Colors.black),
                                                      )),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                      flex: 2,
                                                      child: ItemLabelText(
                                                        text: 'Price',
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            fontFamily: WorkSans
                                                                .semiBold,
                                                            color:
                                                                Colors.black),
                                                      )),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                      flex: 2,
                                                      child: ItemLabelText(
                                                        text: 'Total Price',
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            fontFamily: WorkSans
                                                                .semiBold,
                                                            color:
                                                                Colors.black),
                                                      ))
                                                ],
                                              )
                                            : const SizedBox()
                                        : const SizedBox(),
                                    (snapshot.data!.returns != null)
                                        ? (snapshot.data!.returns!.length > 0)
                                            ? ListView.builder(
                                                itemCount: snapshot
                                                    .data!.returns!.length,
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemBuilder: (b, s) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0,
                                                            bottom: 8.0),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            flex: 1,
                                                            child: Center(
                                                                child:
                                                                    ItemLabelText(
                                                              text: '${s + 1})',
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      WorkSans
                                                                          .regular,
                                                                  color: Colors
                                                                      .black),
                                                            ))),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Expanded(
                                                            flex: 3,
                                                            child:
                                                                ItemLabelText(
                                                              text: snapshot
                                                                  .data!
                                                                  .returns![s]
                                                                  .productName,
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      WorkSans
                                                                          .regular,
                                                                  color: Colors
                                                                      .black),
                                                            )),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Expanded(
                                                            flex: 2,
                                                            child:
                                                                ItemLabelText(
                                                              text: snapshot
                                                                  .data!
                                                                  .returns![s]
                                                                  .quantity,
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      WorkSans
                                                                          .regular,
                                                                  color: Colors
                                                                      .black),
                                                            )),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Expanded(
                                                            flex: 2,
                                                            child:
                                                                ItemLabelText(
                                                              text:
                                                                  '₹ ${snapshot.data!.returns![s].unitPrice}',
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      WorkSans
                                                                          .regular,
                                                                  color: Colors
                                                                      .black),
                                                            )),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Expanded(
                                                            flex: 2,
                                                            child:
                                                                ItemLabelText(
                                                              text:
                                                                  '₹ ${double.parse(snapshot.data!.returns![s].totalPrice!).toStringAsFixed(2)}',
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      WorkSans
                                                                          .regular,
                                                                  color: Colors
                                                                      .black),
                                                            ))
                                                      ],
                                                    ),
                                                  );
                                                })
                                            : const SizedBox()
                                        : const SizedBox(),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    Row(
                                      children: [
                                        ItemLabelText(
                                          text: 'Item Total',
                                          style: const TextStyle(
                                              fontFamily: WorkSans.regular,
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                        const Spacer(),
                                        ItemLabelText(
                                          text:
                                              '₹  ${(double.parse(snapshot.data!.invoiceAmount!) - double.parse(snapshot.data!.gstAmount!)).toStringAsFixed(2)}',
                                          style: const TextStyle(
                                              fontFamily: WorkSans.regular,
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        ItemLabelText(
                                          text: 'Gst',
                                          style: const TextStyle(
                                              fontFamily: WorkSans.regular,
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                        const Spacer(),
                                        ItemLabelText(
                                          text:
                                              '₹ ${(snapshot.data!.gstAmount != null) ? (snapshot.data!.gstAmount!.isNotEmpty) ? double.parse(snapshot.data!.gstAmount!).toStringAsFixed(2) : '' : ''}',
                                          style: const TextStyle(
                                              fontFamily: WorkSans.regular,
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                color: HexColor('#0B8BCB'),
                                padding: const EdgeInsets.only(
                                    top: 15, left: 10, bottom: 15, right: 10),
                                child: Row(
                                  children: [
                                    ItemLabelText(
                                      text: 'Total :',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontFamily: WorkSans.semiBold),
                                    ),
                                    const Spacer(),
                                    ItemLabelText(
                                      text:
                                          '₹ ${double.parse(snapshot.data!.invoiceAmount!).toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontFamily: WorkSans.semiBold),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    ItemLabelText(
                                      text: 'Paid Amount :',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontFamily: WorkSans.semiBold),
                                    ),
                                    const Spacer(),
                                    ItemLabelText(
                                      text: '₹ ${snapshot.data!.paidAmount}',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontFamily: WorkSans.semiBold),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    ItemLabelText(
                                      text: 'Balance  Amount :',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontFamily: WorkSans.semiBold),
                                    ),
                                    const Spacer(),
                                    ItemLabelText(
                                      text: '₹ ${snapshot.data!.balanceAmount}',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontFamily: WorkSans.semiBold),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    ItemLabelText(
                                      text: 'Payment Method :',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontFamily: WorkSans.semiBold),
                                    ),
                                    ItemLabelText(
                                      text: '${snapshot.data!.payMethod}',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontFamily: WorkSans.regular),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ItemLabelText(
                                      text:
                                          'Remarks : ${(snapshot.data!.remarks == null) ? '' : snapshot.data!.remarks}',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontFamily: WorkSans.regular),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    ItemLabelText(
                                      text:
                                          'Delivered On : ${(snapshot.data!.isDeliver == "0") ? '' : snapshot.data!.deliveryDate}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: HexColor('#0B8BCB'),
                                          fontFamily: WorkSans.regular),
                                    ),
                                    const SizedBox(
                                      height: 50,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 5,
                                          child: GestureDetector(
                                            onTap: () async {
                                              // Map<Permission, PermissionStatus>
                                              //     statuses = await [
                                              //   Permission.storage,
                                              // ].request();
                                              // if (statuses[Permission.storage]!
                                              //     .isGranted) {
                                              var imageUrl =
                                                  "${EndPoints.base_url}/api/invoice?API_KEY=640590&order_id=${bloc?.order!.orderId}";
                                              await FileDownloader.downloadFile(
                                                  url: imageUrl,
                                                  name:
                                                      "${bloc?.order!.orderId}invoice.pdf",
                                                  onProgress: (name, progress) {
                                                    setState(() {
                                                      progress = progress;
                                                      status =
                                                          'Progress: $progress%';
                                                    });
                                                    showToastWithBuildContext(
                                                      context,
                                                      const Icon(
                                                        Icons.check,
                                                        color: Colors.white,
                                                      ),
                                                      "Downloading of invoice started",
                                                      Colors.green,
                                                    );
                                                  },
                                                  onDownloadCompleted: (path) {
                                                    setState(() {
                                                      progress = null;
                                                      status =
                                                          'File downloaded to: $path';
                                                    });
                                                    showToastWithBuildContext(
                                                      context,
                                                      const Icon(
                                                        Icons.check,
                                                        color: Colors.white,
                                                      ),
                                                      "Downloading of invoice Completed",
                                                      Colors.green,
                                                    );
                                                    print('FILE: $path');
                                                  },
                                                  onDownloadError: (error) {
                                                    setState(() {
                                                      progress = null;
                                                      status =
                                                          'Download error: $error';
                                                    });
                                                    showToastWithBuildContext(
                                                      context,
                                                      const Icon(
                                                        Icons.check,
                                                        color: Colors.white,
                                                      ),
                                                      "Downloading of invoice failed",
                                                      Colors.red,
                                                    );
                                                  }).then((file) {
                                                debugPrint(
                                                    'file path: ${file?.path}');
                                              });

                                              // bloc!.downloadInvoiceFile(
                                              //     context);
                                              // }
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: 48,
                                              decoration: BoxDecoration(
                                                  color: HexColor('#0B8BCB'),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(5))),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ItemLabelText(
                                                    text: 'Download invoice',
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white,
                                                        fontFamily:
                                                            WorkSans.semiBold),
                                                  ),
                                                  const Icon(
                                                    Icons
                                                        .sim_card_download_rounded,
                                                    color: Colors.white,
                                                    size: 20.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 5,
                                            child: (snapshot.data!.isDeliver ==
                                                    "0")
                                                ? GestureDetector(
                                                    onTap: () {
                                                      bloc!.updateOrder();
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 6),
                                                      height: 48,
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 6,
                                                              right: 6),
                                                      decoration: BoxDecoration(
                                                          color: HexColor(
                                                              '#FFCB04'),
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: ItemLabelText(
                                                        text:
                                                            'Complete Delivery',
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.black,
                                                            fontFamily: WorkSans
                                                                .semiBold),
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox())
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        : const SizedBox();
                  }),
            ),
          ),
        ),
      ),
      bottomNavigationBar: bottomBar(),
    );
  }
}

void showToastWithBuildContext(
  BuildContext context,
  Widget leadingWidget,
  dynamic msgs,
  Color color, {
  Color textColor = Colors.white,
}) {
  FToast fToast = FToast()..init(context);
  // FToast fToast = FToast()..init(navigatorKey.currentContext!);

  List<String> msgsString = [];
  if (msgs is Map) {
    msgs.forEach(
      (key, value) {
        if (value is List) {
          for (String element in value) {
            msgsString.add(element);
          }
        } else if (value is String) {
          msgsString.add(
            value,
          );
        }
      },
    );
  } else if (msgs is String) {
    msgsString.add(msgs);
  } else if (msgs is List<String>) {
    msgsString = msgs;
  }

  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: color,
      ),
      child: Column(
        children: msgsString
            .map(
              (e) => Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  leadingWidget,
                  const SizedBox(
                    width: 12.0,
                  ),
                  Expanded(
                    child: Text(
                      e,
                      overflow: TextOverflow.clip,
                      style: TextStyle(color: textColor, fontSize: 14),
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );

    try {
      fToast.removeCustomToast();
    } catch (e) {}
    fToast.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: const Duration(seconds: 5),
    );
  }

  try {
    _showToast();
  } catch (e, stacktrace) {
    debugPrint(stacktrace.toString());
  }
}
