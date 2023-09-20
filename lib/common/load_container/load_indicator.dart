import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoaderIndicator extends StatelessWidget {
  String get _os => Platform.operatingSystem;

  @override
  Widget build(BuildContext context) {
    return _os == 'ios' ? _getCupertinoIndicator() : _getMaterialIndicator();
  }

  _getCupertinoIndicator() {
    return CupertinoActivityIndicator(
      radius: 15,
    );
  }

  _getMaterialIndicator() {
    return CircularProgressIndicator();
  }
}