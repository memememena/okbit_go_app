import 'package:flutter/material.dart';

// 다크 테마 색상 및 스타일 상수 정의
class DarkTheme {
  static const Color backgroundColor = Colors.black;
  static const Color textColor = Colors.white;
  static const Color unselectedColor = Colors.grey;
  static const TextStyle textStyle = TextStyle(color: textColor);
  static const OutlineInputBorder inputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: textColor),
  );
  static const Color cursorColor = textColor;
}
