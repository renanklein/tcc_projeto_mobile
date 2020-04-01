import 'package:flutter/material.dart';

class AgendaModel {
  String _userId;
  Map<DateTime, List<dynamic>> _events;

  AgendaModel({@required userId, @required events}){
    this._userId = userId;
    this._events = events;
  }  

  String get userId => this._userId;
  Map<DateTime, List<dynamic>> get events => this._events;

  set events(Map events) => this._events = events;
}
