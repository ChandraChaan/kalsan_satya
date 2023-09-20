
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/pyc_colors.dart';


class PYCLabel extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextOverflow? overflow;
  final  int? maxlines;
  final String? labelText;


  PYCLabel({text,style,overflow,maxlines,labelText}):
        this.text=text,
        this.style=style,
        this.overflow=overflow,
        this.maxlines=maxlines,
        this.labelText=labelText
  ;



  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(labelText!, style: TextStyle(color: PYCColors.hint_text_color,fontSize: 14),),
            ),

            Container(
                height: 48,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 10),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: PYCColors.line_secondary),
                  borderRadius: BorderRadius.circular(68,),
                ),
                child: Text(text,style: style,overflow: overflow,maxLines: maxlines,)),
          ],
        ));

  }
}