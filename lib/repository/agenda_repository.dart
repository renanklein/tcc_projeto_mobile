import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AgendaRepository{
   final firestore =  Firestore.instance;
   String userId;
   AgendaRepository({@required this.userId});

   void addEvent(String name, DateTime eventday, List<TimeOfDay> eventDuration) async {
    var dayEvents = await getEvents();
    String eventsKey = _extractDayFromDateTime(eventday);
    List<dynamic> dayEventsAsList = _retrieveListOfEvents(eventday, dayEvents);
    _addNewEvent({
      "description" : name,
      "begin" : eventDuration[0].toString(),
      "end" : eventDuration[1].toString()
    }, dayEventsAsList);

    await Firestore.instance
        .collection("agenda")
        .document(this.userId)
        .collection("events")
        .document(eventsKey)
        .setData({"events": dayEventsAsList})
        .then((resp) => {})
        .catchError((error) => {});
  }

  void removeEvent() {}

  Future<Map<DateTime, List<Map>>> getEvents() async {
    var events;
    await Firestore.instance
        .collection("agenda")
        .document(this.userId)
        .collection("events")
        .getDocuments()
        .then((resp) {
      events = _retriveEventsAsMap(resp.documents);
    });

    return events;
  }

  //documentId -> epoch date
  //dayEvents -> list of events
  Map<DateTime, List<Map>> _retriveEventsAsMap(
      List<DocumentSnapshot> documents) {
    Map<DateTime, List<dynamic>> events = new Map<DateTime, List<dynamic>>();
    documents.forEach((snapshot) {
      var dateFromEpoch =
          DateTime((int.parse(snapshot.documentID)));
      List<dynamic> dayEvents = snapshot.data.values.first;
      events.addAll({dateFromEpoch: dayEvents});
    });

    return events;
  }

  bool _verifyIfExistsEventInThatDay(DateTime eventDay, Map events) {
    return events[eventDay] != null;
  }

  String _extractDayFromDateTime(DateTime eventDay) {
    return "${eventDay.year} - ${eventDay.month} - ${eventDay.day}";
  }


  List<dynamic> _retrieveListOfEvents(DateTime eventDay, Map<DateTime, List<Map>> events) {
    bool existsEventsInThatDay = _verifyIfExistsEventInThatDay(eventDay, events);
    List dayEvents = new List();
    if (existsEventsInThatDay) {
      events[eventDay].forEach((event) => dayEvents.add(event));
    } 
    return dayEvents;
  }

  void _addNewEvent(Map event, List<dynamic> events){
    events.add(event);
  }
}