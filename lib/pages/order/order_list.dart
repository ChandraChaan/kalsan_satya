import 'package:fine_taste/app/arch/bloc_provider.dart';
import 'package:fine_taste/common/load_container/load_container.dart';
import 'package:fine_taste/common/utilities/fonts.dart';
import 'package:fine_taste/common/utilities/ps_colors.dart';
import 'package:fine_taste/di/app_injector.dart';
import 'package:fine_taste/di/i_home_page.dart';
import 'package:fine_taste/pages/store/bloc/store_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

import '../../common/bottom_naviagationbar/bottom_bar.dart';
import '../../common/label/item_label_text.dart';
import '../../common/utilities/convert_date_format.dart';
import '../../model/order/order_response.dart';
import '../../utils/Constants.dart';
import 'bloc/order_list_bloc.dart';

class OrderList extends StatefulWidget {
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  OrderListBloc? bloc;

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
        title: StreamBuilder<int>(
            initialData: 1,
            stream: bloc!.screenType,
            builder: (context, snapshot) {
              return ItemLabelText(
                  text: (snapshot.data == Constants.TODAY_ORDERS)
                      ? 'Today Orders List'
                      : (snapshot.data == Constants.DELIVER_ORDERS)
                          ? 'Deliver Orders'
                          : 'Total Orders',
                  style: const TextStyle(
                      fontFamily: WorkSans.regular,
                      color: Colors.white,
                      fontSize: 18));
            }),
      ),
      body: StreamBuilder<int>(
          initialData: 1,
          stream: bloc!.screenType,
          builder: (context, snapshot) {
            return LoaderContainer(
              stream: bloc!.isLoading,
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    (snapshot.data == Constants.TODAY_ORDERS)
                        ? Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 10),
                                width: MediaQuery.of(context).size.width * 0.95,
                                height: 45,
                                decoration:
                                    BoxDecoration(color: HexColor('#A7A7A7')),
                                child: TextField(
                                  onChanged: (value) {
                                    bloc!.searchData(value);
                                  },
                                  maxLines: 1,
                                  textInputAction: TextInputAction.done,
                                  decoration: const InputDecoration(
                                    hintText: 'Search',
                                    hintStyle: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontFamily: WorkSans.regular),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              /* Container(
                        margin: EdgeInsets.only(left: 3),
                        width: MediaQuery.of(context).size.width*0.10,
                        height: 45,
                        decoration: BoxDecoration(
                            color: Colors.white
                        ),
                        child: Icon(Icons.search),
                      ),*/
                            ],
                          )
                        : Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 10),
                                width: MediaQuery.of(context).size.width * 0.95,
                                height: 45,
                                decoration:
                                    const BoxDecoration(color: Colors.white),
                                child: TextField(
                                  onChanged: (value) {
                                    bloc!.searchData(value);
                                  },
                                  maxLines: 1,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    hintText: 'Search',
                                    hintStyle: TextStyle(
                                        fontSize: 18,
                                        color: HexColor('#A7A7A7'),
                                        fontFamily: WorkSans.regular),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                          alignment: Alignment.centerLeft,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: ItemLabelText(
                                            text: 'From',
                                            style: const TextStyle(
                                                fontFamily: WorkSans.regular,
                                                color: Colors.white,
                                                fontSize: 14),
                                          )),
                                      GestureDetector(
                                        onTap: () {
                                          bloc!.FromDate();
                                        },
                                        child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 5, right: 5),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            height: 40,
                                            decoration: const BoxDecoration(
                                                color: Colors.white),
                                            child: Row(
                                              children: [
                                                Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5, right: 5),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.3,
                                                    child: StreamBuilder<
                                                            String>(
                                                        initialData: '',
                                                        stream: bloc!.fromDate,
                                                        builder: (context,
                                                            snapshot) {
                                                          return ItemLabelText(
                                                            text: snapshot.data,
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    WorkSans
                                                                        .regular,
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14),
                                                          );
                                                        })),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.1,
                                                  alignment: Alignment.center,
                                                  height: 40,
                                                  color: HexColor('#AF4281'),
                                                  child: const Icon(
                                                    Icons.calendar_month,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              ],
                                            )),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                          alignment: Alignment.centerLeft,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: ItemLabelText(
                                            text: 'To',
                                            style: const TextStyle(
                                                fontFamily: WorkSans.regular,
                                                color: Colors.white,
                                                fontSize: 14),
                                          )),
                                      GestureDetector(
                                        onTap: () {
                                          bloc!.ToDate();
                                        },
                                        child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 5, right: 5),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            height: 40,
                                            decoration: const BoxDecoration(
                                                color: Colors.white),
                                            child: Row(
                                              children: [
                                                Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5, right: 5),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.3,
                                                    child: StreamBuilder<
                                                            String>(
                                                        initialData: '',
                                                        stream: bloc!.toDate,
                                                        builder: (context,
                                                            snapshot) {
                                                          return ItemLabelText(
                                                            text: snapshot.data,
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    WorkSans
                                                                        .regular,
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14),
                                                          );
                                                        })),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.1,
                                                  alignment: Alignment.center,
                                                  height: 40,
                                                  color: HexColor('#AF4281'),
                                                  child: const Icon(
                                                    Icons.calendar_month,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              ],
                                            )),
                                      )
                                    ],
                                  ),
                                  /*  Container(
                            margin: EdgeInsets.only(top: 14),
                            width: MediaQuery.of(context).size.width*0.10,
                            height: 40,
                            color: HexColor('#0B8BCB'),
                            child: Icon(Icons.search,color: Colors.white,),
                          )*/
                                ],
                              )
                            ],
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: StreamBuilder<List<Order>>(
                          initialData: [],
                          stream: bloc!.orderList,
                          builder: (context, snapshot) {
                            return (snapshot.data != null)
                                ? (snapshot.data!.isNotEmpty)
                                    ? ListView.builder(
                                        itemCount: snapshot.data!.length,
                                        shrinkWrap: true,
                                        itemBuilder: (b, i) {
                                          return (snapshot.data != null)
                                              ? (snapshot.data!.isNotEmpty)
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        Get.to(AppInjector
                                                            .instance
                                                            .orderDetails(
                                                                snapshot
                                                                    .data![i]));
                                                      },
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                            top: 10,
                                                            bottom: 10),
                                                        decoration:
                                                            const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5)),
                                                          gradient:
                                                              LinearGradient(
                                                            colors: [
                                                              Colors.white,
                                                              Color(0xff0B8BCB),
                                                            ],
                                                            stops: [0.24, 0.24],
                                                            tileMode:
                                                                TileMode.decal,
                                                          ),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              width: 100,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Center(
                                                                      child:
                                                                          ItemLabelText(
                                                                    text:
                                                                        '# ${snapshot.data![i].orderId}',
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontFamily:
                                                                            WorkSans
                                                                                .semiBold,
                                                                        color: Colors
                                                                            .black),
                                                                  )),
                                                                  Center(
                                                                      child:
                                                                          ItemLabelText(
                                                                    text: ConvertDateFormat.customDate(snapshot
                                                                        .data![
                                                                            i]
                                                                        .orderDate!),
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontFamily:
                                                                            WorkSans
                                                                                .semiBold,
                                                                        color: Colors
                                                                            .black),
                                                                  )),
                                                                ],
                                                              ),
                                                            ),
                                                            Flexible(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    const SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    ItemLabelText(
                                                                      text:
                                                                          '${snapshot.data![i].storeName}',
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontFamily: WorkSans
                                                                              .semiBold,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Align(
                                                                        alignment:
                                                                            Alignment
                                                                                .centerLeft,
                                                                        child:
                                                                            ItemLabelText(
                                                                          text:
                                                                              'Total Invoice : ${snapshot.data![i].invoiceAmount}',
                                                                          style: const TextStyle(
                                                                              fontSize: 14,
                                                                              fontFamily: WorkSans.regular,
                                                                              color: Colors.white),
                                                                        )),
                                                                    const SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    GridView
                                                                        .count(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              6),
                                                                      crossAxisCount:
                                                                          2,
                                                                      childAspectRatio:
                                                                          3,
                                                                      crossAxisSpacing:
                                                                          1,
                                                                      mainAxisSpacing:
                                                                          10,
                                                                      physics:
                                                                          const ClampingScrollPhysics(),
                                                                      shrinkWrap:
                                                                          true,
                                                                      children: List.generate(
                                                                          snapshot
                                                                              .data![
                                                                                  i]
                                                                              .items!
                                                                              .length,
                                                                          (index) {
                                                                        return ItemLabelText(
                                                                          text:
                                                                              '${snapshot.data![i].items![index].productName} : ${double.parse(snapshot.data![i].items![index].totalPrice!).toStringAsFixed(2)} ',
                                                                          style: const TextStyle(
                                                                              fontSize: 14,
                                                                              fontFamily: WorkSans.regular,
                                                                              color: Colors.white),
                                                                        );
                                                                      }),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .height,
                                                      child: Center(
                                                        child: ItemLabelText(
                                                          text: 'No Data',
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20,
                                                              fontFamily:
                                                                  WorkSans
                                                                      .semiBold),
                                                        ),
                                                      ),
                                                    )
                                              : Container(
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .height,
                                                  child: Center(
                                                    child: ItemLabelText(
                                                      text: 'No Data',
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontFamily: WorkSans
                                                              .semiBold),
                                                    ),
                                                  ),
                                                );
                                        })
                                    : Container(
                                        height:
                                            MediaQuery.of(context).size.height,
                                        child: Center(
                                          child: ItemLabelText(
                                            text: 'No Data',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontFamily: WorkSans.semiBold),
                                          ),
                                        ),
                                      )
                                : Container(
                                    height: MediaQuery.of(context).size.height,
                                    child: Center(
                                      child: ItemLabelText(
                                        text: 'No Data',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontFamily: WorkSans.semiBold),
                                      ),
                                    ),
                                  );
                          }),
                    )
                  ],
                ),
              ),
            );
          }),
      bottomNavigationBar: bottomBar(),
    );
  }
}
