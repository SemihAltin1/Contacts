import 'package:flutter/material.dart';

class TextStyles {

  static  TextStyle titleLarge({Color? color}) => TextStyle(
    fontFamily: "Nunito Bold",
    fontSize: 24,
    color: color ?? Colors.black,
  );

  static  TextStyle bodyLarge({Color? color}) => TextStyle(
    fontFamily: "Nunito Bold",
    fontSize: 16,
    color: color ?? Colors.black,
  );

  static  TextStyle bodySmall({Color? color}) => TextStyle(
    fontFamily: "Nunito Medium",
    fontSize: 16,
    color: color ?? Colors.black,
  );

}