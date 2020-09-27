import 'package:flutter/material.dart';

class ProblemModel {
  String _description;
  String _problemId;
  String _date;

  ProblemModel({
    @required String description,
    @required String problemId,
    @required String date,
  }) {
    this._description = description;
    this._problemId = problemId;
    this._date = date;
  }

  Map<String, dynamic> toMap() {
    return {
      'description': _description,
      'id': _problemId,
      'date': _date,
    };
  }

  static ProblemModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ProblemModel(
      description: map['description'],
      problemId: map['id'],
      date: map['date'],
    );
  }

  //String get email => this._email;
  //set userUid(String uid) => this._userId = uid;
}
