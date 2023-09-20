
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/pyc_colors.dart';
import '../fonts/fonts.dart';
import '../utilities/fonts.dart';

class PYCCustomTextField extends StatelessWidget {
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
  final _validationStream;
  final _onChange;

  PYCCustomTextField(
      {labelText,
        hintText = '',
        initialText = '',
        obscureText = false,
        height = 150.0,
        inputAction,
        keyboardType,
        charactersLimit,
        linesLimit = 10,
        focusNode,
        onSubmit,
        validationStream,
        onChange})
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
        builder: (c, s) {
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (labelText!="")?Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(labelText, style: TextStyle(color: Colors.black,fontFamily:WorkSans.semiBold,fontSize: 16),),
                ):SizedBox(),
                SizedBox(
                  height: 180,
                  child: TextField(
                    key: Key(labelText),
                   // controller: _controller,
                    keyboardType: keyboardType,
                    textInputAction: inputAction,
                    maxLines: linesLimit,
                    onChanged: _onChange,
                    style: TextStyle(fontFamily: Fonts.regular,fontSize: 14,color: Colors.black),
                    onSubmitted: _onSubmit,
                    obscureText: obscureText,
                    focusNode: _focusNode,
                    inputFormatters: [
                      if (charactersLimit != null)
                        LengthLimitingTextInputFormatter(charactersLimit)
                    ],
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: TextStyle(fontFamily: Fonts.regular,fontSize: 14,color: PYCColors.hint_text_color),
                      focusedBorder:
                      OutlineInputBorder(
                          borderSide: BorderSide(color: PYCColors.line_secondary),
                          borderRadius: BorderRadius.circular(24)),
                      enabledBorder:
                      OutlineInputBorder(
                          borderSide: BorderSide(color: PYCColors.line_secondary),
                          borderRadius: BorderRadius.circular(24)),
                    ),
                  ),
                ),
                (s.data.toString()!="")?Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(s.data!, style: TextStyle(color: Colors.red,fontSize:10),),
                ):SizedBox()
              ],
            ),
          );
        },
      ),
    );
  }
}