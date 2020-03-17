import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/utils/convert_utils.dart';

class AgendaRepository {
  final firestore = Firestore.instance;
  String userId;
  Map<DateTime, dynamic> _events;
  AgendaRepository({@required this.userId});

  set events(Map<DateTime, dynamic> events) => this._events = events;

  void addEvent(
      String name, DateTime eventday, List<TimeOfDay> eventDuration) async {
    String eventsKey = ConvertUtils.dayFromDateTime(eventday);
    List<dynamic> dayEventsAsList = _retrieveListOfEvents(eventday, _events);
    _addNewEvent({
      "description": name,
      "begin": ConvertUtils.fromTimeOfDay(eventDuration[0]),
      "end": ConvertUtils.fromTimeOfDay(eventDuration[1])
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

  Future<Map<DateTime, List<Map<dynamic, dynamic>>>> getEvents() async {
    var events;
    await Firestore.instance
        .collection("agenda")
        .document(this.userId)
        .collection("events")
        .getDocuments()
        .then((resp) {
      events = _retriveEventsForAgenda(resp.documents);
    });

    return events;
  }

  //documentId -> epoch date
  //dayEvents -> list of events
  Map<DateTime, List<String>> _retriveEventsForAgenda(
      List<DocumentSnapshot> documents) {
    Map<DateTime, List<String>> events = new Map<DateTime, List<String>>();
    documents.forEach((snapshot) {
      var dateFromEpoch = DateTime((int.parse(snapshot.documentID)));
      List<Map> dayEvents = snapshot.data.values.first;

      events.addAll(
          {dateFromEpoch: ConvertUtils.toStringListOfEvents(dayEvents)});
    });

    return events;
  }

  bool _verifyIfExistsEventInThatDay(DateTime eventDay, Map events) {
    return events[eventDay] != null;
  }

  List<dynamic> _retrieveListOfEvents(
      DateTime eventDay, Map<DateTime, List<Map>> events) {
    bool existsEventsInThatDay =
        _verifyIfExistsEventInThatDay(eventDay, events);
    List dayEvents = new List();
    if (existsEventsInThatDay) {
      events[eventDay].forEach((event) => dayEvents.add(event));
    }
    return dayEvents;
  }

  void _addNewEvent(Map event, List<dynamic> events) {
    events.add(event);
  }
}
