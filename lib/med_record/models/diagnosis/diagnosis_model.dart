import 'package:flutter/material.dart';

class DiagnosisModel {
  String _description;
  String _cid;
  String _date;

  DiagnosisModel({
    @required String description,
    @required String cid,
    @required String date,
  }) {
    this._description = description;
    this._cid = cid;
    this._date = date;
  }

  Map<String, dynamic> toMap() {
    return {
      'description': _description,
      'id': _cid,
      'date': _date,
    };
  }

  static DiagnosisModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return DiagnosisModel(
      description: map['description'],
      cid: map['id'],
      date: map['date'],
    );
  }

  //String get email => this._email;
  //set userUid(String uid) => this._userId = uid;
}
