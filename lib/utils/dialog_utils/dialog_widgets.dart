import 'package:flutter/material.dart';

Widget messageSnackBar(
    context, String message, Color backGroundColor, Color fontColor) {
  Scaffold.of(context).showSnackBar(SnackBar(
    backgroundColor: backGroundColor,
    content: Text(
      message,
      style: TextStyle(
          fontSize: 16.0, fontWeight: FontWeight.w500, color: fontColor),
    ),
  ));
}
