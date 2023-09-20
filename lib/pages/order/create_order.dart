import 'package:fine_taste/common/toast/toast.dart';
import 'package:fine_taste/helper/logger/logger.dart';
import 'package:fine_taste/model/store/products_response.dart';
import 'package:fine_taste/pages/order/widget/success_dialog.dart';
import 'package:fine_taste/pages/repositories/end_point/end_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

import '../../app/arch/bloc_provider.dart';
import '../../common/bottom_naviagationbar/bottom_bar.dart';
import '../../common/label/item_label_text.dart';
import '../../common/load_container/load_container.dart';
import '../../common/textfield/pyc_custom_text_filed.dart';
import '../../common/utilities/fonts.dart';
import '../../common/utilities/ps_colors.dart';
import '../../model/store/store_list_response.dart';
import 'bloc/create_order_bloc.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'dart:typed_data';

import 'package:screenshot/screenshot.dart';

class CreateOrder extends StatefulWidget {
  _CreateOrderState createState() => _CreateOrderState();
}

class _CreateOrderState extends State<CreateOrder> {
  CreateOrderBloc? bloc;
  double itemSubTotal = 0.0;
  double itemRetTotal = 0.0;
  int? initialValue;
  final focusNode = FocusNode();
  ScreenshotController screenshotController = ScreenshotController();
  final GlobalKey globalKey = GlobalKey();



  @override
  void initState() {
    bloc = BlocProvider.of(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: PSColors.bg_color,
      appBar: AppBar(
          backgroundColor: PSColors.app_color,
          centerTitle: true,
          title: Column(
            children: [
              ItemLabelText(
                  text: 'Create Order',
                  style: const TextStyle(
                      fontFamily: WorkSans.regular,
                      color: Colors.white,
                      fontSize: 18)),
              ItemLabelText(
                  text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                  style: const TextStyle(
                      fontFamily: WorkSans.regular,
                      color: Colors.white,
                      fontSize: 18)),
            ],
          )),
      body: LoaderContainer(
        stream: bloc!.isLoading,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: HexColor('#FFCB04'),
                    padding: const EdgeInsets.all(20),
                    child: StreamBuilder<Store>(
                        initialData: null,
                        stream: bloc!.storeData,
                        builder: (context, snapshot) {
                          return (snapshot.data != null)
                              ? Column(
                                  children: [
                                    ItemLabelText(
                                      text: snapshot.data!.storeName!,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontFamily: WorkSans.semiBold),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ItemLabelText(
                                      text: '${snapshot.data!.address!} Ph :${snapshot.data!.mobile!}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontFamily: WorkSans.regular),
                                    )
                                  ],
                                )
                              : const SizedBox();
                        }),
                  ),
                  Column(
                    children: [
                      StreamBuilder<List<Product>>(
                          initialData: [],
                          stream: bloc!.productList,
                          builder: (context, snapshot) {
                            return (snapshot.data!.length > 0)
                                ? ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (b, s) {
                                      if (snapshot.data![s].qty == null) {
                                        snapshot.data![s].qty = 0;
                                      }

                                      if (snapshot.data![s].total == null) {
                                        snapshot.data![s].total = 0.0;
                                      }
                                      return Column(
                                        children: [
                                          Container(
                                            color: HexColor('#0B8BCB'),
                                            padding: const EdgeInsets.only(
                                                top: 8.0, bottom: 8.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: Column(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 25,
                                                        backgroundColor:
                                                            Colors.grey,
                                                        child: Image.network(
                                                            EndPoints.base_url +
                                                                snapshot
                                                                    .data![s]
                                                                    .image!,
                                                            errorBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    Object
                                                                        exception,
                                                                    StackTrace?
                                                                        stackTrace) {
                                                          return Image.asset(
                                                              'assets/images/splash_logo.png');
                                                        }),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 4,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      ItemLabelText(
                                                        text: snapshot.data![s]
                                                            .productName,
                                                        style: const TextStyle(
                                                            fontSize: 18,
                                                            fontFamily: WorkSans
                                                                .regular,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      const SizedBox(
                                                        height: 6,
                                                      ),
                                                      SizedBox(
                                                        height: 40,
                                                        width: 70,
                                                        child: TextFormField(
                                                          style: const TextStyle(fontSize: 18,
                                                                  fontFamily: WorkSans
                                                                      .regular,),
                                                          textAlign: TextAlign.center,
                                                            keyboardType: TextInputType.phone,
                                                            initialValue:initialValue==0? initialValue.toString():snapshot.data![s].qty !=null ? snapshot .data![s].qty.toString() : '0',
                                                            inputFormatters: [
                                                              LengthLimitingTextInputFormatter(3),
                                                              FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
                                                          decoration:  InputDecoration(
                                                            contentPadding: const EdgeInsets.only(bottom: 2),
                                                            filled: true,
                                                            fillColor: Colors.white,
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(30.0),
                                                              borderSide: const BorderSide(color: Colors.grey,
                                                                      width: 2),
                                                            ),
                                                            focusedBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(30.0),
                                                              borderSide: const BorderSide(color: Colors.grey,
                                                                      width: 2),
                                                            )),
                                                          onChanged: (val) {
                                                            setState(() {
                                                                if(val.isNotEmpty){
                                                                   initialValue =1;
                                                                   snapshot.data![s].qty= int.parse(val);
                                                                   (snapshot.data![s].qty==null) ?snapshot.data![s].qty=0:snapshot.data![s].qty=snapshot.data![s].qty;
                                                                   snapshot.data![s].total=snapshot.data![s].qty! * double.parse(snapshot.data![s].price!);
                                                                   bloc!.addProductList.add(snapshot.data!);
                                                                   printLog("snapshot.data![s].total", snapshot.data![s].total);
                                                                   itemSubTotal = snapshot.data!.fold(0, (tot, item) => tot.toDouble() + item.total!);
                                                                   printLog("title", itemSubTotal);
                                                                   bloc!.addItemTotal.add(itemSubTotal-itemRetTotal);
                                                                }
                                                                else{
                                                                  snapshot.data![s].qty= 0;
                                                                  (snapshot.data![s].qty==null) ?snapshot.data![s].qty=0:snapshot.data![s].qty=snapshot.data![s].qty;
                                                                  snapshot.data![s].total=snapshot.data![s].qty! * double.parse(snapshot.data![s].price!);
                                                                  bloc!.addProductList.add(snapshot.data!);
                                                                  printLog("snapshot.data![s].total", snapshot.data![s].total);
                                                                  itemSubTotal = snapshot.data!.fold(0, (tot, item) => tot.toDouble() + item.total!);
                                                                  printLog("title", itemSubTotal);
                                                                  bloc!.addItemTotal.add(itemSubTotal-itemRetTotal);
                                                                }
                                                            });
                                                          },

                                                          onFieldSubmitted: (value) {
                                                            setState(() {
                                                              initialValue = value.isEmpty?int.parse("0"):int.parse(value);
                                                            });
                                                            focusNode.unfocus();
                                                          },
                                                        ),
                                                      ),
                                                      // Row(
                                                      //   mainAxisAlignment: MainAxisAlignment.center,
                                                      //   crossAxisAlignment: CrossAxisAlignment.center,
                                                      //   children: [
                                                      //     GestureDetector(
                                                      //         onTap:(){
                                                      //           (snapshot.data![s].qty==null)
                                                      //               ?snapshot.data![s].qty=0:snapshot.data![s].qty=snapshot.data![s].qty;
                                                      //
                                                      //           if(snapshot.data![s].qty!>0) {
                                                      //             snapshot.data![s].qty=snapshot.data![s].qty!-1;
                                                      //           } else {
                                                      //             snapshot.data![s].qty=0;
                                                      //           }
                                                      //
                                                      //           snapshot.data![s].total=snapshot.data![s].qty! * double.parse(snapshot.data![s].price!);
                                                      //           bloc!.addProductList.add(snapshot.data!);
                                                      //
                                                      //           itemSubTotal = snapshot.data!.fold(0, (tot, item) => tot.toDouble() + item.total!);
                                                      //           printLog("title", itemSubTotal);
                                                      //           bloc!.addItemTotal.add(itemSubTotal-itemRetTotal);
                                                      //         },
                                                      //         child: Image.asset('assets/images/minus.png')),
                                                      //     const SizedBox(width: 6,),
                                                      // ItemLabelText(
                                                      //   text: (snapshot.data![s]
                                                      //               .qty !=
                                                      //           null)
                                                      //       ? snapshot
                                                      //           .data![s].qty
                                                      //           .toString()
                                                      //       : '0',
                                                      //   style: const TextStyle(
                                                      //       fontSize: 18,
                                                      //       fontFamily: WorkSans
                                                      //           .regular,
                                                      //       color:
                                                      //           Colors.white),
                                                      // ),
                                                      //     const SizedBox(width: 6,),
                                                      //     GestureDetector(
                                                      //         onTap:(){
                                                      //           (snapshot.data![s].qty==null)
                                                      //             ?snapshot.data![s].qty=0:snapshot.data![s].qty=snapshot.data![s].qty;
                                                      //
                                                      //           snapshot.data![s].qty=snapshot.data![s].qty!+1;
                                                      //           snapshot.data![s].total=snapshot.data![s].qty! * double.parse(snapshot.data![s].price!);
                                                      //           bloc!.addProductList.add(snapshot.data!);
                                                      //           printLog("snapshot.data![s].total", snapshot.data![s].total);
                                                      //            itemSubTotal = snapshot.data!.fold(0, (tot, item) => tot.toDouble() + item.total!);
                                                      //            printLog("title", itemSubTotal);
                                                      //            bloc!.addItemTotal.add(itemSubTotal-itemRetTotal);
                                                      //
                                                      //         },
                                                      //         child: Image.asset('assets/images/add.png'))
                                                      //   ],
                                                      // )
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Center(
                                                      child: ItemLabelText(
                                                    text:
                                                        '₹ ${(snapshot.data![s].qty != null) ? (snapshot.data![s].qty! > 0) ? (snapshot.data![s].qty! * double.parse(snapshot.data![s].price!)).toStringAsFixed(2) : double.parse(snapshot.data![s].price!).toStringAsFixed(2) : double.parse(snapshot.data![s].price!).toStringAsFixed(2)}',
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontFamily:
                                                            WorkSans.regular,
                                                        color: Colors.white),
                                                  )),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Divider(
                                            color: Colors.white,
                                            height: 0.5,
                                          )
                                        ],
                                      );
                                    })
                                : ItemLabelText(
                                    text: 'No Data',
                                  );
                          }),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: HexColor('#AF4281'),
                    padding:
                        const EdgeInsets.only(top: 15, left: 15, bottom: 15),
                    child: ItemLabelText(
                      text: 'Returns / Expired',
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: WorkSans.semiBold),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  StreamBuilder<List<Product>>(
                      initialData: [],
                      stream: bloc!.returnProductList,
                      builder: (context, snap) {
                        return (snap.data!.length > 0)
                            ? ListView.builder(
                                itemCount: snap.data!.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (b, r) {
                                  if (snap.data![r].qty == null) {
                                    snap.data![r].qty = 0;
                                  }
                                  if (snap.data![r].total == null) {
                                    snap.data![r].total = 0.0;
                                  }

                                  return Column(
                                    children: [
                                      Container(
                                        color: HexColor('#0B8BCB'),
                                        padding: const EdgeInsets.only(
                                            top: 8.0, bottom: 8.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: CircleAvatar(
                                                radius: 25,
                                                backgroundColor: Colors.grey,
                                                child: Image.network(
                                                    EndPoints.base_url +
                                                        snap.data![r].image!,
                                                    errorBuilder:
                                                        (BuildContext context,
                                                            Object exception,
                                                            StackTrace?
                                                                stackTrace) {
                                                  return Image.asset(
                                                      'assets/images/splash_logo.png');
                                                }),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  ItemLabelText(
                                                    text: snap.data![r].productName,
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontFamily:
                                                            WorkSans.regular,
                                                        color: Colors.white),
                                                  ),
                                                  const SizedBox(
                                                    height: 6,
                                                  ),
                                                  SizedBox(
                                                    height: 40,
                                                    width: 70,
                                                    child: TextFormField(
                                                      style: const TextStyle(fontSize: 18,
                                                        fontFamily: WorkSans.regular,),
                                                      textAlign: TextAlign.center,
                                                      keyboardType: TextInputType.phone,
                                                      initialValue: (snap.data![r].qty != null) ? snap.data![r].qty.toString() : '0',
                                                      inputFormatters: [
                                                        LengthLimitingTextInputFormatter(3),
                                                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
                                                      decoration:  InputDecoration(
                                                          contentPadding: const EdgeInsets.only(bottom: 2),
                                                          filled: true,
                                                          fillColor: Colors.white,
                                                          border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(30.0),
                                                            borderSide: const BorderSide(color: Colors.grey,
                                                                width: 2
                                                            ),
                                                          ),
                                                          focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(30.0),
                                                            borderSide: const BorderSide(color: Colors.grey,
                                                                width: 2),
                                                          )),
                                                      onChanged: (val) {
                                                        setState(() {
                                                        if(val.isNotEmpty){
                                                          if (itemSubTotal > 0.0) {
                                                            snap.data![r].qty= int.parse(val);
                                                            (snap.data![r].qty == null) ? snap.data![r].qty = 0 : snap.data![r].qty = snap.data![r].qty;
                                                            snap.data![r].total = snap.data![r].qty! * double.parse(snap.data![r].price!);
                                                            bloc!.addReturnProductList.add(snap.data!);
                                                            itemRetTotal = snap.data!.fold(0, (tot, item) => tot.toDouble() + item.total!);
                                                            printLog("title", itemRetTotal);
                                                            bloc!.addItemTotal.add(itemSubTotal - itemRetTotal);
                                                          } else {
                                                            ToastMessage('Please add items');
                                                             }
                                                          }
                                                        else{
                                                          // if (itemSubTotal > 0.0) {
                                                          //   snap.data![r].qty=0;
                                                          //   (snap.data![r].qty == null) ? snap.data![r].qty = 0 : snap.data![r].qty = snap.data![r].qty;
                                                          //   snap.data![r].total = snap.data![r].qty! * double.parse(snap.data![r].price!);
                                                          //   bloc!.addReturnProductList.add(snap.data!);
                                                          //   itemRetTotal = snap.data!.fold(0, (tot, item) => tot.toDouble() + item.total!);
                                                          //   printLog("title", itemRetTotal);
                                                          //   bloc!.addItemTotal.add(itemSubTotal - itemRetTotal);
                                                          // } else {
                                                          //   ToastMessage('Please add items');
                                                          // }
                                                        }
                                                        });


                                                      },

                                                    ),
                                                  ),

                                                  // Row(
                                                  //   mainAxisAlignment:
                                                  //       MainAxisAlignment
                                                  //           .center,
                                                  //   crossAxisAlignment:
                                                  //       CrossAxisAlignment
                                                  //           .center,
                                                  //   children: [
                                                  //     GestureDetector(
                                                  //         onTap: () {
                                                  //           if (itemSubTotal > 0.0) {
                                                  //             (snap.data![s].qty == null) ? snap.data![s].qty = 0 : snap.data![s].qty = snap.data![s].qty;
                                                  //             if (snap.data![s].qty! > 0) {
                                                  //               snap.data![s].qty = snap.data![s].qty! - 1;
                                                  //             } else {
                                                  //               snap.data![s].qty = 0;
                                                  //             }
                                                  //             snap.data![s].total = snap.data![s].qty! * double.parse(snap.data![s].price!);
                                                  //             bloc!.addReturnProductList.add(snap.data!);
                                                  //             itemRetTotal = snap.data!.fold(0, (tot, item) => tot.toDouble() + item.total!);
                                                  //             printLog("title", itemRetTotal);
                                                  //             bloc!.addItemTotal.add(itemSubTotal - itemRetTotal);
                                                  //           } else {
                                                  //             ToastMessage('Please add items');
                                                  //           }
                                                  //         },
                                                  //         child: Image.asset('assets/images/minus.png')),
                                                  //     const SizedBox(
                                                  //       width: 6,
                                                  //     ),
                                                  //     ItemLabelText(
                                                  //       text: (snap.data![s].qty != null) ? snap.data![s].qty.toString() : '0',
                                                  //       style: const TextStyle(
                                                  //           fontSize: 18,
                                                  //           fontFamily: WorkSans.regular,
                                                  //           color: Colors.white),
                                                  //     ),
                                                  //     const SizedBox(
                                                  //       width: 6,
                                                  //     ),
                                                  //     GestureDetector(
                                                  //         onTap: () {
                                                  //           if (itemSubTotal > 0.0) {
                                                  //             (snap.data![s].qty == null) ? snap.data![s].qty = 0 : snap.data![s].qty = snap.data![s].qty;
                                                  //             snap.data![s].qty = snap.data![s].qty! + 1;
                                                  //             snap.data![s].total = snap.data![s].qty! * double.parse(snap.data![s].price!);
                                                  //             bloc!.addReturnProductList.add(snap.data!);
                                                  //             itemRetTotal = snap.data!.fold(0, (tot, item) => tot.toDouble() + item.total!);
                                                  //             printLog("title", itemRetTotal);
                                                  //             bloc!.addItemTotal.add(itemSubTotal - itemRetTotal);
                                                  //           } else {
                                                  //             ToastMessage('Please add items');
                                                  //           }
                                                  //         },
                                                  // //         child: Image.asset(
                                                  //             'assets/images/add_w.png'))
                                                  //   ],
                                                  // )
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Center(
                                                  child: ItemLabelText(
                                                text:
                                                    '₹ ${(snap.data![r].qty != null) ? (snap.data![r].qty! > 0) ? (snap.data![r].qty! * double.parse(snap.data![r].price!)).toStringAsFixed(2) : double.parse(snap.data![r].price!).toStringAsFixed(2) : double.parse(snap.data![r].price!).toStringAsFixed(2)}',
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontFamily:
                                                        WorkSans.regular,
                                                    color: Colors.white),
                                              )),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(
                                        color: Colors.white,
                                        height: 0.5,
                                      )
                                    ],
                                  );
                                })
                            : ItemLabelText(
                                text: 'No Data',
                              );
                      }),
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            ItemLabelText(
                              text: 'Previous Balance',
                              style: const TextStyle(
                                  fontFamily: WorkSans.regular,
                                  color: Colors.black,
                                  fontSize: 16),
                            ),
                            const Spacer(),
                            StreamBuilder<double>(
                                initialData: 0.0,
                                stream: bloc!.previousBalance,
                                builder: (context, snapshot) {
                                  return ItemLabelText(
                                    text:
                                        '₹ ${snapshot.data!.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontFamily: WorkSans.regular,
                                        color: Colors.black,
                                        fontSize: 16),
                                  );
                                }),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
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
                            StreamBuilder<double>(
                                initialData: 0.0,
                                stream: bloc!.itemTotal,
                                builder: (context, snapshot) {
                                  return ItemLabelText(
                                    text:
                                        '₹ ${snapshot.data!.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontFamily: WorkSans.regular,
                                        color: Colors.black,
                                        fontSize: 16),
                                  );
                                }),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Row(
                              children: [
                                StreamBuilder<bool>(
                                    initialData: false,
                                    stream: bloc!.isTax,
                                    builder: (b, sap) {
                                      return IconButton(
                                          onPressed: () {
                                            (sap.data == true)
                                                ? bloc!.addIsTax.add(false)
                                                : bloc!.addIsTax.add(true);
                                          },
                                          icon: Icon((sap.data == true)
                                              ? Icons.check_box_outlined
                                              : Icons
                                                  .check_box_outline_blank_outlined));
                                    }),
                                ItemLabelText(
                                  text: 'Include Gst',
                                  style: const TextStyle(
                                      fontFamily: WorkSans.regular,
                                      color: Colors.black,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                            const Spacer(),
                            StreamBuilder<double>(
                                initialData: 0.0,
                                stream: bloc!.taxAmount,
                                builder: (context, snapshot) {
                                  return ItemLabelText(
                                    text:
                                        '₹ ${snapshot.data!.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontFamily: WorkSans.regular,
                                        color: Colors.black,
                                        fontSize: 16),
                                  );
                                }),
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
                        StreamBuilder<double>(
                            initialData: 0.0,
                            stream: bloc!.totalAmount,
                            builder: (context, snapshot) {
                              return ItemLabelText(
                                text: '₹ ${snapshot.data!.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontFamily: WorkSans.semiBold),
                              );
                            }),
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
                        Container(
                            width: 100,
                            height: 40,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: HexColor('#707070'))),
                            child: TextField(
                              onChanged: bloc!.paidAmount.add,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontFamily: WorkSans.semiBold),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            )),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 3,
                    color: HexColor('#30395D'),
                  ),
                  Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: ItemLabelText(
                                text: 'Payment Method',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: WorkSans.semiBold),
                              )),
                          ListView.builder(
                              itemCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (b, i) {
                                return StreamBuilder<int>(
                                    initialData: 0,
                                    stream: bloc!.selectPos,
                                    builder: (context, shot) {
                                      return GestureDetector(
                                        onTap: () {
                                          bloc!.addSelectPos.add(i);
                                          i==0?commonPopupDialog(context):const SizedBox();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          margin: const EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          decoration: BoxDecoration(
                                              color: HexColor((i == shot.data)
                                                  ? '#83A925'
                                                  : '#A7A7A7'),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5))),
                                          child: Row(
                                            children: [
                                              Image.asset((i == 0)
                                                  ? 'assets/images/online.png'
                                                  : 'assets/images/cash.png'),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              ItemLabelText(
                                                text: (i == 0)
                                                    ? 'Online'
                                                    : 'Cash',
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontFamily:
                                                        WorkSans.regular),
                                              ),
                                              const Spacer(),
                                              (i == shot.data)
                                                  ? const Icon(
                                                      Icons
                                                          .radio_button_checked,
                                                      color: Colors.black,
                                                    )
                                                  : const Icon(
                                                      Icons.circle_outlined,
                                                      color: Colors.white,
                                                    )
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              }),
                          PYCCustomTextField(
                            labelText: 'Remarks',
                            hintText: 'Enter text...',
                            inputAction: TextInputAction.done,
                            keyboardType: TextInputType.multiline,
                            onChange: bloc!.remarks.add,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              bloc!.create.add(null);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(left: 10),
                              height: 48,
                              padding: const EdgeInsets.only(left: 6, right: 6),
                              decoration: BoxDecoration(
                                  color: HexColor('#FFCB04'),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5))),
                              child: ItemLabelText(
                                text: 'Confirm Order',
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontFamily: WorkSans.semiBold),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: bottomBar(),
    );
  }

  Future commonPopupDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StreamBuilder<ProductsResponse>(
          stream: bloc!.productsResponse,
          builder: (context, snapshot) {
            return snapshot.data!=null ?Dialog(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context, true);
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.black,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Image.network(snapshot.data!.qrCode!,
                           fit: BoxFit.fill),
                      ),

                      // Screenshot(
                      //   key: globalKey,
                      //   controller: screenshotController,
                      //   child: QrImageView(
                      //     data: snapshot.data!.qrCode!,
                      //     version: QrVersions.auto,
                      //     size: 250.0,
                      //   ),
                      // ),
                      const SizedBox(height:20),
                      Row(
                        children: [
                          const Text("Bank Name : ",style: TextStyle(
                            fontSize: 16,fontWeight: FontWeight.w600
                          )
                            ,),
                          Text(snapshot.data!.bankDetails.bankName!,style: const TextStyle(
                              fontSize: 16,fontWeight: FontWeight.w600
                          )),
                        ],
                      ),
                      const SizedBox(height: 5,),
                      Row(
                        children: [
                          const Text("Account Number : ",style: TextStyle(
                              fontSize: 16,fontWeight: FontWeight.w600
                          )),
                          Text(snapshot.data!.bankDetails.accountNumber!,style: const TextStyle(
                              fontSize: 16,fontWeight: FontWeight.w600
                          )),
                        ],
                      ),
                      const SizedBox(height: 5,),
                      Row(
                        children: [
                          const Text("Branch : ",style: TextStyle(
                              fontSize: 16,fontWeight: FontWeight.w600
                          )),
                          Text(snapshot.data!.bankDetails.branch!,style: const TextStyle(
                              fontSize: 16,fontWeight: FontWeight.w600
                          )),
                        ],
                      ),
                      const SizedBox(height: 5,),
                      Row(
                        children: [
                          const Text("IFSC Code : ",style: TextStyle(
                              fontSize: 16,fontWeight: FontWeight.w600
                          )),
                          Text(snapshot.data!.bankDetails.ifscCode!,style: const TextStyle(
                              fontSize: 16,fontWeight: FontWeight.w600
                          )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ):const SizedBox();
          }
        );
      },
    );
  }

}
