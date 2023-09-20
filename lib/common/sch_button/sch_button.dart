
import 'package:flutter/material.dart';

class SCHCustomButton extends StatelessWidget {
  final String title;
  final VoidCallback _onTap;
  final Color titleColor;
  final backgroundColor;
  final double height;
  final isSelected;
  final selectedBorderColors;
  final borderColor;
  final titleSelectedColor;
  final selectedColor;
  double? _borderRadius;
  TextStyle? _textStyle;

  SCHCustomButton(
      {radius,
        style,
        title,
        isSelected = false,
        titleSelectedColor,
        selectedBorderColor = Colors.transparent,
        borderColor = Colors.transparent,
        selectedColor,
        onTap,
        titleColor = Colors.white,
        backgroundColor = Colors.white,
        height = 40.0})
      : this.title = title,
        _onTap = onTap,
        this.isSelected = isSelected,
        this.selectedBorderColors = selectedBorderColor,
        this.borderColor = borderColor,
        this.titleSelectedColor = titleSelectedColor,
        this.titleColor = titleColor,
        this.selectedColor = selectedColor,
        this.backgroundColor = backgroundColor,
        this.height = height {
    _borderRadius = radius;
    _textStyle = style;

    if (_borderRadius == null) _borderRadius = 10;
    if (_textStyle == null)
      _textStyle =
          TextStyle(color: isSelected ? titleSelectedColor : titleColor);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: height,
        decoration: BoxDecoration(
            color: isSelected ? selectedColor : backgroundColor,
            borderRadius: BorderRadius.circular(_borderRadius!),
            border: Border.all(
                color: isSelected ? selectedBorderColors : borderColor,
                width: 1)),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 10, left: 10),
            child: TextField(
              textAlign: TextAlign.center,
              style: _textStyle,
            ),
          ),
        ),
      ),
      onTap: _onTap,
    );
  }
}

class PYCCustomButtonGreen extends SCHCustomButton {
  PYCCustomButtonGreen(
      {title, onTap, isSelected = false, double? radius, TextStyle? style})
      : super(
      style: style,
      radius: radius,
      title: title,
      isSelected: isSelected,
      selectedColor: Colors.black12,
      selectedBorderColor: Colors.black12,
      borderColor: Colors.black12,
      titleSelectedColor: Colors.white,
      titleColor: Colors.white,
      onTap: onTap,
      backgroundColor: Colors.black12);
}