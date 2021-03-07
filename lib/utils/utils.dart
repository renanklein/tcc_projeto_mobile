import 'package:cloud_firestore/cloud_firestore.dart';

import 'convert_utils.dart';

class Utils {
  static Map<DateTime, List<String>> retriveEventsForAgenda(
      List<DocumentSnapshot> documents) {
    Map<DateTime, List<String>> events = new Map<DateTime, List<String>>();

    documents.forEach((snapshot) {
      var dateFromEpoch = ConvertUtils.documentIdToDateTime(snapshot.id);
      var dayEvents = snapshot.data().values.first;
      var eventsAsListOfString = ConvertUtils.toStringListOfEvents(dayEvents);
      if (eventsAsListOfString.isNotEmpty) {
        events.addAll({dateFromEpoch: eventsAsListOfString});
      }
    });

    return events;
  }

  static bool verifyIfExistsEventInThatDay(DateTime eventDay, Map events) {
    return events[eventDay] != null;
  }

  static List<dynamic> retrieveListOfEvents(DateTime eventDay, dynamic events) {
    bool existsEventsInThatDay = verifyIfExistsEventInThatDay(eventDay, events);
    List dayEvents = [];
    if (existsEventsInThatDay) {
      events[eventDay].forEach((event) => dayEvents.add(event));
    }
    return dayEvents;
  }

  static void addNewEvent(Map event, List<dynamic> events) {
    events.add(event);
  }

  static Map buildNewEvent(Map eventParameters) {
    var filteredDate = ConvertUtils.removeTime(eventParameters["eventDay"]);
    var events = retrieveListOfEvents(filteredDate, eventParameters["events"]);
    List<dynamic> dayEventsAsList = ConvertUtils.toMapListOfEvents(events);
    int eventId =
        dayEventsAsList.isEmpty ? 1 : int.parse(dayEventsAsList.last["id"]) + 1;

    var newEvent = {
      "id": eventId.toString(),
      "userId": eventParameters["userId"],
      "description": eventParameters["name"],
      "begin": eventParameters["eventDuration"].first,
      "end": eventParameters["eventDuration"].last,
      "phone": eventParameters["phone"],
      "status": "created"
    };

    Utils.addNewEvent(newEvent, dayEventsAsList);

    return {
      "eventsKey": ConvertUtils.dayFromDateTime(eventParameters["eventDay"]),
      "dayEventsAsList": dayEventsAsList,
      "newEvent": newEvent
    };
  }

  static Map buildUpdateEvent(Map eventParameters) {
    var filteredDate = ConvertUtils.removeTime(eventParameters["eventDay"]);
    var dayEvent = eventParameters["events"][filteredDate];
    var listEvents = ConvertUtils.toMapListOfEvents(dayEvent);
    var newEvent = eventParameters["newEvent"];

    var oldEvent = listEvents
        .where((event) => event["id"] == newEvent["id"])
        .toList()
        .first;
    newEvent["status"] = oldEvent["status"];

    if (eventParameters["reason"] != null) {
      newEvent["reason"] = eventParameters["reason"];
    }

    listEvents.remove(oldEvent);
    newEvent["status"] = eventParameters["status"];
    listEvents.add(newEvent);

    return {"filteredDate": filteredDate, "events": listEvents};
  }
}
