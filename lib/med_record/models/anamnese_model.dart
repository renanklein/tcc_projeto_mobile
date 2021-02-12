import 'package:flutter/material.dart';

class AnamneseModel {
  int _age;
  String _smoking;
  String _drinking;

  AnamneseModel({
    @required int age,
    @required String smoking,
    @required String drinking,
  }) {
    this._age = age;
    this._smoking = smoking;
    this._drinking = drinking;
  }

  Map<String, dynamic> toMap() {
    return {
      'age': _age as String,
      'smoking': _smoking,
      'drinking': _drinking,
    };
  }

  static AnamneseModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return AnamneseModel(
      age: int.parse(map['age']),
      smoking: map['smoking'],
      drinking: map['drinking'],
    );
  }

}
