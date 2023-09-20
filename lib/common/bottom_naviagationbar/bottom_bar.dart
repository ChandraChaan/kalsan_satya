import 'package:fine_taste/common/utilities/ps_colors.dart';
import 'package:fine_taste/di/i_home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../di/app_injector.dart';

Widget bottomBar(){
  return SizedBox(
    height: 48,
    child: Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: PSColors.app_color,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (value){
          if(value==0){
            Get.to(AppInjector.instance.homePage);
          }else  if(value==1){
            Get.to(AppInjector.instance.profilePage);
          }else if(value==2){
            Get.to(AppInjector.instance.homePage);
          }else if(value==3){
            Get.to(AppInjector.instance.notification);
          }

        },
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home,size: 18,),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,size: 18,),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard,size: 18,),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications,size: 18,),
            label: '',
          ),
        ],

      ),
    ),
  );
}