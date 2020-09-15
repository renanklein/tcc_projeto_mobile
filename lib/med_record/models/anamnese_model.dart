import 'package:flutter/material.dart';

class AnamneseModel {
  int _age;
  bool _smoking;
  bool _drinking;

  AnamneseModel({
    @required int age,
    @required bool smoking,
    @required bool drinking,
  }) {
    this._age = age;
    this._smoking = smoking;
    this._drinking = drinking;
  }

  Map<String, dynamic> toMap() {
    return {
      'age': _age as String,
      'smoking': _smoking == false ? 'não' : 'sim',
      'drinking': _drinking == false ? 'não' : 'sim',
    };
  }

  static AnamneseModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return AnamneseModel(
      age: map['age'],
      smoking: map['smoking'],
      drinking: map['drinking'],
    );
  }

  //String get email => this._email;
  //set userUid(String uid) => this._userId = uid;
}
