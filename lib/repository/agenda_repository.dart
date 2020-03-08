import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AgendaRepository{
   final firestore =  Firestore.instance;
   String userId;
   AgendaRepository({@required this.userId});

   void addEvent(String name, DateTime date) async {
    var dayEvents = await getEvents();
    String eventsKey = _dayEventAsMilisecondEpoch(date);
    List<dynamic> updatedDayEvents = _retrieveListOfEvents(date, name, dayEvents);
    await Firestore.instance
        .collection("agenda")
        .document(this.userId)
        .collection("events")
        .document(eventsKey)
        .setData({"dayEvents": updatedDayEvents})
        .then((resp) => {})
        .catchError((error) => {});
  }

  void removeEvent() {}

  Future<Map<DateTime, List<dynamic>>> getEvents() async {
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
  Map<DateTime, List<dynamic>> _retriveEventsAsMap(
      List<DocumentSnapshot> documents) {
    Map<DateTime, List<dynamic>> events = new Map<DateTime, List<dynamic>>();
    documents.forEach((snapshot) {
      var dateFromEpoch =
          DateTime.fromMillisecondsSinceEpoch(int.parse(snapshot.documentID));
      List<dynamic> dayEvents = snapshot.data.values.first;
      events.addAll({dateFromEpoch: dayEvents});
    });

    return events;
  }

  bool _verifyIfExistsEventInThatDay(DateTime eventDay, Map events) {
    return events[eventDay] != null;
  }

  String _dayEventAsMilisecondEpoch(DateTime eventDay) {
    var dateTimestamp = Timestamp.fromDate(eventDay);
    return dateTimestamp.millisecondsSinceEpoch.toString();
  }

  List<dynamic> _retrieveListOfEvents(DateTime eventDay, String event, Map<DateTime, List<dynamic>> events) {
    bool existsEventsInThatDay = _verifyIfExistsEventInThatDay(eventDay, events);
    List dayEvents = new List();
    if (existsEventsInThatDay) {
      events[eventDay].forEach((event) => dayEvents.add(event));
    } 

    dayEvents.add(event);
    
    return dayEvents;
  }
}