import 'package:flutter/material.dart';

class CommonMedRecordModel {
  String _type;
  String _description;
  String _id;
  String _date;

  CommonMedRecordModel({
    @required String type,
    @required String description,
    @required String id,
    @required String date,
  }) {
    this._type = type;
    this._description = description;
    this._id = id;
    this._date = date;
  }

  Map<String, dynamic> toMap() {
    return {
      'type': _type,
      'description': _description,
      'id': _id,
      'date': _date,
    };
  }

  static CommonMedRecordModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return CommonMedRecordModel(
      type: map['type'],
      description: map['description'],
      id: map['id'],
      date: map['date'],
    );
  }

  //String get email => this._email;
  //set userUid(String uid) => this._userId = uid;
}
