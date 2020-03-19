import 'package:flutter/material.dart';

class ConvertUtils{
  static String fromTimeOfDay(TimeOfDay time){
    return "${time.hour}:${time.minute}";
  }

  static String dayFromDateTime(DateTime date){
    return "${date.year}-${date.month}-${date.day}";
  }

  static List<String> toStringListOfEvents(List events){
    List<String> eventsParsed = new List<String>();

    events.forEach((event){
      eventsParsed.add("${event["description"]};${event["begin"]};${event["end"]}");
    });

    return eventsParsed;
  }

  static List<Map> toMapListOfEvents(List<String> events){

    if(events == null){
      return List<Map>();
    }
    List<Map> eventsParsed = new List<Map>();

    events.forEach((eventString){
      var eventsData = eventString.split(";"); 
      
      eventsParsed.add({
        "description" : eventsData[0],
        "begin" : eventsData[1],
        "end" : eventsData[2]
      });
    });

    return eventsParsed;
  }

  static documentIdToDateTime(String documentId){
    var splitedDocumentId = documentId.split("-");

    return DateTime(
      int.parse(splitedDocumentId[0]),
      int.parse(splitedDocumentId[1]),
      int.parse(splitedDocumentId[2])
    );
  }
}