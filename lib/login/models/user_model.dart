import 'package:flutter/material.dart';

class UserModel {
  String _email;
  String _name;
  String _uid;
  String _access;

  UserModel({
    @required String email,
    @required String name,
    @required String uid,
    @required String access,
  }) {
    this._email = email;
    this._name = name;
    this._uid = uid;
    this._access = access;
  }

  String get email => this._email;
  String get name => this._name;
  String get uid => this._uid;
  String get getAccess => this._access;
}
