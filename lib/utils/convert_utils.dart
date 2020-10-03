import 'package:flutter/material.dart';

class ConvertUtils {
  static String fromTimeOfDay(TimeOfDay time) {
    return "${time.hour}:${time.minute}";
  }

  static String dayFromDateTime(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }

  static DateTime removeTime(DateTime date) {
    var listDate = dayFromDateTime(date).split("-");

    return new DateTime(
        int.parse(listDate[0]), int.parse(listDate[1]), int.parse(listDate[2]));
  }

  static List<String> toStringListOfEvents(List events) {
    List<String> eventsParsed = new List<String>();

    events.forEach((event) {
      if (event["status"] != "canceled") {
        eventsParsed.add(
            "${event["id"]};${event["description"]};${event["begin"]};${event["end"]};${event["status"]};${event["userId"]};${event["phone"]}");
      }
    });
    return eventsParsed;
  }

  static List<Map> toMapListOfEvents(List events) {
    if (events == null) {
      return List<Map>();
    }
    List<Map> eventsParsed = new List<Map>();

    events.forEach((eventString) {
      var eventsData = eventString.split(";");
      if (eventsData[4] != "canceled") {
        eventsParsed.add({
          "id": eventsData[0],
          "description": eventsData[1],
          "begin": eventsData[2],
          "end": eventsData[3],
          "status": eventsData[4],
          "userId": eventsData[5],
          "phone": eventsData[6]
        });
      }
    });

    return eventsParsed;
  }

  static documentIdToDateTime(String documentId) {
    var splitedDocumentId = documentId.split("-");

    return DateTime(int.parse(splitedDocumentId[0]),
        int.parse(splitedDocumentId[1]), int.parse(splitedDocumentId[2]));
  }

  static List<String> getOccupedHours(List events) {
    var occupedHours = new List<String>();

    events.forEach((event) {
      if (event["status"] != "canceled") {
        var occupedHour = "${event["begin"]} - ${event["end"]}";
        occupedHours.add(occupedHour);
      }
    });

    return occupedHours;
  }
}
