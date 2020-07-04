import 'package:flutter/material.dart';

Widget MyTextStyle(
    String text, FontWeight fontWeight, Color color, double size) {
  return Text(
    text,
    style: TextStyle(
        fontSize: size,
        color: color,
        fontWeight: fontWeight,
        fontFamily: 'Open Sans'),
  );
}
