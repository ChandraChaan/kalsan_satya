import 'package:fine_taste/common/label/item_label_text.dart';
import 'package:fine_taste/common/utilities/fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';


void SuccessDialog(){
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return AlertDialog(
        titlePadding: EdgeInsets.zero,
        actionsPadding: EdgeInsets.zero,
        backgroundColor: HexColor('#0B8BCB'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        content:Container(
          height: MediaQuery.of(context).size.height*0.45,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child:IconButton(icon:  Icon(Icons.cancel_outlined,color: Colors.white,),onPressed: (){
                  Navigator.pop(context);
                 // Navigator.pop(context);
                },)
              ),
              Container(
               alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/package.png'),
                    SizedBox(height: 30,),
                    ItemLabelText(text: 'Delivery Successful !',style: TextStyle(fontSize: 20,color: Colors.white,fontFamily: WorkSans.regular),),

                  ],
                ),
              )
            ],
          ),
        )
      );
    },
  );
}