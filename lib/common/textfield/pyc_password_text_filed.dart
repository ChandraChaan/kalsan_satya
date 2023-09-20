
import 'package:fine_taste/utils/pyc_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../fonts/fonts.dart';


class PYCPasswordTextField extends StatelessWidget {
  final _controller = TextEditingController();

  final labelText;
  final hintText;
  final initialText;
  final obscureText;
  final double height;
  final inputAction;
  final keyboardType;
  final int linesLimit;
  final int? charactersLimit;
  final _focusNode;
  final _onSubmit;
  final  _iconStream;
  final _onChange;
  final Function(bool value)?  _onPressed;
  final _validationStream;

  PYCPasswordTextField(
      {labelText,
        hintText = '',
        initialText = '',
        obscureText = false,
        height = 50.0,
        inputAction,
        keyboardType,
        charactersLimit,
        linesLimit = 1,
        focusNode,
        onSubmit,
        iconStream,
        onChange,onPressed, validationStream})
      : this.labelText = labelText,
        this.hintText = hintText,
        this.initialText = initialText,
        this.obscureText = obscureText,
        this.height = height,
        this.inputAction = inputAction,
        this.charactersLimit=charactersLimit,
        this.linesLimit = linesLimit,
        this.keyboardType = keyboardType,
        _focusNode = focusNode,
        _onSubmit = onSubmit,
        _iconStream = iconStream,
        _onPressed=onPressed,
        _validationStream = validationStream,
        _onChange = onChange {
    _controller.text = initialText;
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: StreamBuilder<String>(
          initialData: '',
          stream: _validationStream,
          builder: (con, snap){
            return StreamBuilder<bool>(
              initialData: false,
              stream: _iconStream,
              builder: (c, s) {
                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (labelText!="")?Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(labelText, style: TextStyle(color: PYCColors.hint_text_color,fontSize: 14,fontFamily: Fonts.regular),),
                      ):SizedBox(),
                      SizedBox(
                        height: 58,
                        child: TextField(
                          keyboardType: keyboardType,
                          textInputAction: inputAction,
                          maxLines: linesLimit,
                          onChanged: _onChange,
                          style:  TextStyle(color: Colors.black,fontSize: 14,fontFamily: Fonts.regular),
                          onSubmitted: _onSubmit,
                          obscureText:  s.data!,
                          focusNode: _focusNode,
                          inputFormatters: [
                            if (charactersLimit != null)
                              LengthLimitingTextInputFormatter(charactersLimit)
                          ],
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: hintText,
                            hintStyle:  TextStyle(color: PYCColors.hint_text_color,fontSize: 14,fontFamily: Fonts.regular),
                            focusedBorder:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(68)),
                            enabledBorder:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(68)),
                            suffixIcon: IconButton(
                              icon: s.data! ? Icon(Icons.visibility_off,size: 16,color: Colors.black,) : Icon(Icons.visibility,size: 16,color: Colors.black),
                              onPressed:() => _onPressed!(s.data! ? false:true),


                            ),
                          ),
                        ),
                      ),
                      (snap.data.toString()!="")?Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(snap.data!, style: TextStyle(color: Colors.red,fontSize:10),),
                      ):SizedBox()
                    ],
                  ),
                );
              },
            );
          }
      )


    );
  }
}