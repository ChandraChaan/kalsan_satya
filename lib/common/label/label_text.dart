

import 'package:flutter/cupertino.dart';

class LabelText extends StatelessWidget{
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;


  LabelText(this.text, this.style, this.textAlign);

  @override
  Widget build(BuildContext context) {
    return Text(text,style: style,);

  }

}