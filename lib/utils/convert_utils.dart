import 'package:flutter/material.dart';

class ConvertUtils{
  static String fromTimeOfDay(TimeOfDay time){
    return "${time.hour}:${time.minute}";
  }

  static String dayFromDateTime(DateTime date){
    return "${date.year}-${date.month}-${date.day}";
  }

  static List<String> toStringListOfEvents(List<Map> events){
    List<String> eventsParsed = new List<String>();

    events.forEach((event){
      eventsParsed.add("${event["description"]};${event["begin"]};${event["end"]}");
    });

    return eventsParsed;
  }
}