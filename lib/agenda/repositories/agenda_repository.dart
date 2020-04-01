import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/utils/convert_utils.dart';

class AgendaRepository {
  final firestore = Firestore.instance;
  String _userId;
  Map<DateTime, dynamic> _events;

  set events(Map<DateTime, dynamic> events) => this._events = events;
  set userId(String uid) => this._userId = uid;

  Future<void> addEvent(String name, DateTime eventday, List<TimeOfDay> eventDuration) async {
    String eventsKey = ConvertUtils.dayFromDateTime(eventday);
    var filteredDate = ConvertUtils.removeTime(eventday);
    List<dynamic> dayEventsAsList = ConvertUtils.toMapListOfEvents(_retrieveListOfEvents(filteredDate, _events));
    int eventId =  dayEventsAsList.isEmpty ? 1  : int.parse(dayEventsAsList.last["id"]) + 1;

    _addNewEvent({
      "id" : eventId.toString(),
      "description": name,
      "begin": ConvertUtils.fromTimeOfDay(eventDuration[0]),
      "end": ConvertUtils.fromTimeOfDay(eventDuration[1]),
      "status" : "created"
    }, dayEventsAsList);

    await Firestore.instance
        .collection("agenda")
        .document(this._userId)
        .collection("events")
        .document(eventsKey)
        .setData({"events": dayEventsAsList})
        .then((resp) => {})
        .catchError((error) => {});
  }

  Future<Map<DateTime, List>> getEvents() async {
    var events;
    await Firestore.instance
        .collection("agenda")
        .document(this._userId)
        .collection("events")
        .getDocuments()
        .then((resp) {
      events = _retriveEventsForAgenda(resp.documents);
    });

    return events;
  }

  Future<void> updateEvent(DateTime eventDay, String eventId, Map newEvent) async{
    var events = await getEvents();

    var filteredDate = ConvertUtils.removeTime(eventDay);

    var dayEvent = events[filteredDate];

    var listEvents = ConvertUtils.toMapListOfEvents(dayEvent);

    var oldEvent = listEvents.where((event) => event["id"] == newEvent["id"]).toList().first;

    listEvents.remove(oldEvent);

    listEvents.add(newEvent);

    await firestore
      .collection("agenda")
      .document(this._userId)
      .collection("events")
      .document(ConvertUtils.dayFromDateTime(filteredDate))
      .updateData({
       "events" : listEvents 
      });
  }

  Future removeEvent(DateTime eventDay, String eventId) async{
    var events = await getEvents();

    var filteredDate = ConvertUtils.removeTime(eventDay);

    var dayEvent = events[filteredDate];

    var listEvents = ConvertUtils.toMapListOfEvents(dayEvent);

    var oldEvent = listEvents.where((event) => event["id"] == eventId).toList().first;

    listEvents.remove(oldEvent);

    await firestore
      .collection("agenda")
      .document(this._userId)
      .collection("events")
      .document(ConvertUtils.dayFromDateTime(filteredDate))
      .updateData({
       "events" : listEvents 
      });
  }

  //documentId -> epoch date
  //dayEvents -> list of events
  Map<DateTime, List<String>> _retriveEventsForAgenda(
      List<DocumentSnapshot> documents) {
    Map<DateTime, List<String>> events = new Map<DateTime, List<String>>();
    documents.forEach((snapshot) { 
      var dateFromEpoch = ConvertUtils.documentIdToDateTime(snapshot.documentID);
      var dayEvents = snapshot.data.values.first;

      events.addAll(
          {dateFromEpoch: ConvertUtils.toStringListOfEvents(dayEvents)});
    });

    return events;
  }

  bool _verifyIfExistsEventInThatDay(DateTime eventDay, Map events) {
    return events[eventDay] != null;
  }

  List<dynamic> _retrieveListOfEvents(DateTime eventDay, dynamic events) {

    bool existsEventsInThatDay = _verifyIfExistsEventInThatDay(eventDay, events);
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
