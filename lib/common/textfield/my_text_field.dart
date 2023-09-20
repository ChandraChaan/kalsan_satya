import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utilities/ps_colors.dart';


class MyTextField extends StatelessWidget {
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
  final bool? readOnly;

  MyTextField(
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
        validationStream,
        onChange,readOnly})
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
        this.readOnly=readOnly,
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
                Container(
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: PSColors.app_color),
                      borderRadius: BorderRadius.all(Radius.circular(5))
                  ),
                  height: 48,
                  child: TextField(
                    key: Key(labelText),
                     controller: _controller,
                    keyboardType: keyboardType,
                    textInputAction: inputAction,
                    maxLines: linesLimit,
                    readOnly: (readOnly!=null)?readOnly!:false,
                    onChanged: _onChange,
                    style: TextStyle(fontSize: 14,color: Colors.black),
                    onSubmitted: _onSubmit,
                    obscureText: obscureText,
                    focusNode: _focusNode,
                    inputFormatters: [
                      if (charactersLimit != null)
                        FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: TextStyle(fontSize: 14,color: PSColors.hint_text_color),
                      border: InputBorder.none,
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