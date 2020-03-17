import 'package:flutter/material.dart';

class ConvertUtils{
  static String fromTimeOfDay(TimeOfDay time){
    return "${time.hour}:${time.minute}";
  }

  static String dayFromDateTime(DateTime date){
    return "${date.year}-${date.month}-${date.day}";
  }
}