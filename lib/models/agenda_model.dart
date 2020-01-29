import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class AgendaModel extends Model {
  List<Map<String, dynamic>> _events;
  FirebaseUser _user;

  AgendaModel({@required FirebaseUser user}) {
    this._user = user;
  }

  void addEvent(String name, DateTime date) {
    Firestore.instance
        .collection("agenda")
        .document(_user.uid)
        .collection("events")
        .add({"name": name, "date": date})
        .then((resp) => {})
        .catchError((error) => {});
  }

  void removeEvent() {}

  List<dynamic> getEvents() {
    Firestore.instance
        .collection("agenda")
        .document(this._user.uid)
        .collection("events")
        .getDocuments()
        .then((resp) {
          this._events = resp.documents.map((d) => d.data).toList();
        });
  }
}
