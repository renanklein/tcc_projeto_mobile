import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class AgendaModel extends Model {
  Map<DateTime, List<dynamic>> _events;
  FirebaseUser _user;
  bool isLoading = true;

  AgendaModel({@required FirebaseUser user}) {
    this._user = user;
    this._events = new Map<DateTime, List<dynamic>>();
  }
  void addEvent(String name, DateTime date) async {
    // map => date - events in that day
    // date key aways in miliseconds. This is the document key
    // in firebase
    String eventsKey = _dayEventAsMilisecondEpoch(date);
    List<dynamic> updatedDayEvents = _retrieveListOfEvents(date, name);
    await Firestore.instance
        .collection("agenda")
        .document(this._user.uid)
        .collection("events")
        .document(eventsKey)
        .setData({"dayEvents": updatedDayEvents})
        .then((resp) => {
        })
        .catchError((error) => {});
  }

  void removeEvent() {}

  Future<Map<DateTime, List<dynamic>>> getEvents() async {
    this.isLoading = true;
    await Firestore.instance
        .collection("agenda")
        .document(this._user.uid)
        .collection("events")
        .getDocuments()
        .then((resp) {
      this._events = _retriveEventsAsMap(resp.documents);
      this.isLoading = false;
    }).catchError((error) {
      this.isLoading = false;
    });

    return this._events;
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

  bool _verifyIfExistsEventInThatDay(DateTime eventDay) {
    return this._events[eventDay] != null;
  }

  String _dayEventAsMilisecondEpoch(DateTime eventDay) {
    var dateTimestamp = Timestamp.fromDate(eventDay);
    return dateTimestamp.millisecondsSinceEpoch.toString();
  }

  List<dynamic> _retrieveListOfEvents(DateTime eventDay, String event) {
    bool existsEventsInThatDay = _verifyIfExistsEventInThatDay(eventDay);
    List dayEvents = new List();
    if (existsEventsInThatDay) {
      this._events[eventDay].forEach((event) => dayEvents.add(event));
    }

    dayEvents.add(event);

    return dayEvents;
  }
}
