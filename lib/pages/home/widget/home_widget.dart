import 'package:fine_taste/common/utilities/fonts.dart';
import 'package:fine_taste/common/utilities/ps_colors.dart';
import 'package:fine_taste/di/app_injector.dart';
import 'package:fine_taste/di/i_home_page.dart';
import 'package:fine_taste/model/store/last_invoice_response.dart';
import 'package:fine_taste/utils/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';


Widget HomeWidget(LastInvoiceResponse response) {
  return Container(
    padding: const EdgeInsets.all(10),
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 5,
              child: GestureDetector(
                onTap: () {
                  Get.to(
                      AppInjector.instance.orderList(Constants.TODAY_ORDERS));
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                      color: HexColor('#0B8BCB'),
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text(
                              'Today \nOrders',
                              style: TextStyle(
                                  fontFamily: WorkSans.regular,
                                  fontSize: 16,
                                  color: PSColors.white_color),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                               '${response.counts!.todayOrders}',
                              style: TextStyle(
                                  fontFamily: WorkSans.semiBold,
                                  fontSize: 22,
                                  color: PSColors.white_color),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SvgPicture.asset('assets/images/today_order.svg')
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: GestureDetector(
                onTap: () {
                  Get.to(
                      AppInjector.instance.orderList(Constants.DELIVER_ORDERS));
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                      color: HexColor('#0B8BCB'),
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text(
                              'Delivery\nOrder',
                              style: TextStyle(
                                  fontFamily: WorkSans.regular,
                                  fontSize: 16,
                                  color: PSColors.white_color),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                               '${response.counts!.deliverOrders}',
                              style: TextStyle(
                                  fontFamily: WorkSans.medium,
                                  fontSize: 22,
                                  color: PSColors.white_color),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SvgPicture.asset('assets/images/deliver_order.svg')
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Expanded(
              flex: 5,
              child: GestureDetector(
                onTap: () {
                  Get.to(
                      AppInjector.instance.orderList(Constants.TOTAL_ORDERS));
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                      color: HexColor('#0B8BCB'),
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text(
                              'Total \nOrders',
                              style: TextStyle(
                                  fontFamily: WorkSans.regular,
                                  fontSize: 16,
                                  color: PSColors.white_color),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                               '${response.counts!.totalOrders}',
                              style: TextStyle(
                                  fontFamily: WorkSans.semiBold,
                                  fontSize: 22,
                                  color: PSColors.white_color),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SvgPicture.asset('assets/images/today_order.svg')
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
                flex: 5,
                child: GestureDetector(
                  onTap: () {
                    Get.to(AppInjector.instance.storeList(1));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                        color: HexColor('#0B8BCB'),
                        borderRadius: const BorderRadius.all(Radius.circular(5))),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Text(
                                'Store \nList',
                                style: TextStyle(
                                    fontFamily: WorkSans.regular,
                                    fontSize: 16,
                                    color: PSColors.white_color),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                 '${response.counts!.storesCount}',
                                style: TextStyle(
                                    fontFamily: WorkSans.medium,
                                    fontSize: 22,
                                    color: PSColors.white_color),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SvgPicture.asset('assets/images/store_list.svg')
                      ],
                    ),
                  ),
                ))
          ],
        )
      ],
    ),
  );
}


