import 'package:flutter/material.dart';

class UserModel {
  String _email;
  String _name;
  String _uid;

  UserModel({
    @required String email,
    @required String name,
    @required String uid,
  }) {
    this._email = email;
    this._name = name;
    this._uid = uid;
  }

  String get email => this._email;
  String get name => this._name;
  String get uid => this._uid;
}
