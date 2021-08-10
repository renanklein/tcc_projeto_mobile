import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConvertUtils {
  static List<String> getTotalHours() {
    return <String>[
      "08:00 - 08:30",
      "08:30 - 09:00",
      "09:00 - 09:30",
      "09:30 - 10:00",
      "10:00 - 10:30",
      "10:30 - 11:00",
      "11:00 - 11:30",
      "11:30 - 12:00",
      "12:00 - 12:30",
      "12:30 - 13:00",
      "13:00 - 13:30",
      "13:30 - 14:00",
      "14:00 - 14:30",
      "14:30 - 15:00",
      "15:00 - 15:30",
      "15:30 - 16:00",
      "16:00 - 16:30",
      "16:30 - 17:00",
      "17:00 - 17:30",
      "17:30 - 18:00",
      "18:00 - 18:30",
      "18:30 - 19:00",
      "19:00 - 19:30",
      "19:30 - 20:00",
      "20:00 - 20:30",
      "20:30 - 21:00"
    ];
  }

  static String fromTimeOfDay(TimeOfDay time) {
    return "${time.hour}:${time.minute}";
  }

  static DateTime dateTimeFromString(String date) {
    var splitted = date.contains("/") ? date.split("/") : date.split("-");

    return DateTime(int.tryParse(splitted[2]), int.tryParse(splitted[1]),
        int.tryParse(splitted[0]));
  }

  static String dayFromDateTime(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static DateTime removeTime(DateTime date) {
    var listDate = dayFromDateTime(date).split("-");

    return new DateTime(
        int.parse(listDate[0]), int.parse(listDate[1]), int.parse(listDate[2]));
  }

  static List<String> toStringListOfEvents(List events) {
    List<String> eventsParsed = <String>[];

    events.forEach((event) {
      if (event["status"] != "canceled") {
        eventsParsed.add(
            "${event["id"]};${event["description"]};${event["begin"]};${event["end"]};${event["status"]};${event["userId"]};${event["phone"]}");
      }
    });
    return eventsParsed;
  }

  static List mapConfirmedEvents(List events) {
    var listOfEvents = [];
    events.forEach((event) {
      if (event['status'] != "confirmed" && event["status"] != "canceled") {
        listOfEvents.add(event);
      }
    });

    return listOfEvents;
  }

  static List<Map> toMapListOfEvents(List events) {
    if (events == null) {
      return <Map>[];
    }
    List<Map> eventsParsed = <Map>[];

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
    var occupedHours = <String>[];

    events.forEach((event) {
      if (event["status"] != "canceled") {
        var occupedHour = "${event["begin"]} - ${event["end"]}";
        occupedHours.add(occupedHour);
      }
    });

    return occupedHours;
  }
}
