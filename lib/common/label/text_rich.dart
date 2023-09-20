import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

class TextRich extends StatelessWidget{
  final String? title;
  final TextStyle? textStyle;
  final String? title_sub;
  final TextStyle? textStyle_sub;
  final VoidCallback?  onPressed;
  TextRich({title,textStyle,title_sub,textStyle_sub,onPressed}):this.title=title,this.textStyle=textStyle,this.title_sub=title_sub,
  this.textStyle_sub=textStyle_sub,
        this.onPressed=onPressed;

  @override
  Widget build(BuildContext context) {
   return  Text.rich(
     TextSpan(
       text: title,
       style: textStyle,
       children: <TextSpan>[
         TextSpan(
           recognizer: new TapGestureRecognizer()..onTap = onPressed,
             text: title_sub,
             style: textStyle_sub,)
         // can add more TextSpans here...
       ],
     ),
   );
  }

}