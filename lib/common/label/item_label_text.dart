

import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

class ItemLabelText extends StatelessWidget{
  final String text;
  final TextStyle? style;
  final TextOverflow? overflow;
  final  int? maxlines;
  final TextAlign? textAlignment;



  ItemLabelText({text,style,overflow,maxlines,textAlignment}):
        this.text=text,
        this.style=style,
        this.overflow=overflow,
        this.maxlines=maxlines,this.textAlignment=textAlignment;



  @override
  Widget build(BuildContext context) {
    return Text(text,style: style,overflow: overflow,maxLines: maxlines,textAlign: textAlignment,);

  }

}