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

  static UserModel fromMap(Map<String, dynamic> map, String userUid) {
    if (map == null) return null;

    return UserModel(
      email: map["email"],
      name: map["name"],
      access: map["access"],
      uid: userUid,
    );
  }

  String get email => this._email;
  String get name => this._name;
  String get uid => this._uid;
  String get getAccess => this._access;
}
