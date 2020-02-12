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
    // under construction ...
    await Firestore.instance
        .collection("agenda")
        .document(_user.uid)
        .collection("events")
        .add({"name": name, "date": date})
        .then((resp) => {})
        .catchError((error) => {});
  }

  void removeEvent() {}


 Map<DateTime, List<dynamic>> getEvents(){
   this.isLoading = true;
   Firestore.instance
        .collection("agenda")
        .document(this._user.uid)
        .collection("events")
        .getDocuments()
        .then((resp) {
          this._events = _retriveEventsAsMap(resp.documents);
          this.isLoading = false;
          notifyListeners();
        })
        .catchError((error){
          this.isLoading = false;
          notifyListeners();
        });

    return this._events;
  }

  
  //documentId -> epoch date
  //dayEvents -> list of events
  Map<DateTime, List<dynamic>> _retriveEventsAsMap(List<DocumentSnapshot> documents){
    Map<DateTime, List<dynamic>> events = new Map<DateTime, List<dynamic>>();
    documents.forEach((snapshot){
       var dateFromEpoch = DateTime.fromMillisecondsSinceEpoch(int.parse(snapshot.documentID));
       List<dynamic> dayEvents = snapshot.data.values.first;
       events.addAll({dateFromEpoch : dayEvents});
    });

    return events;
  }
}

