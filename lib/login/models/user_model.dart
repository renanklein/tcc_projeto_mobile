import 'package:flutter/material.dart';

class UserModel {
  String _email;
  String _name;
  String _uid;
  String _access;
  String _medicId;

  UserModel({
    @required String email,
    @required String name,
    @required String uid,
    @required String access,
    String medicId,
  }) {
    this._email = email;
    this._name = name;
    this._uid = uid;
    this._access = access;
    this._medicId = medicId;
  }

  static UserModel fromMap(Map<String, dynamic> map, String userUid) {
    if (map == null) return null;

    return UserModel(
      email: map["email"],
      name: map["name"],
      access: map["access"],
      uid: userUid,
      medicId: map["medicId"],
    );
  }

  String get email => this._email;
  String get name => this._name;
  String get uid => this._uid;
  String get getMedicId => this._medicId;
  String get getAccess => this._access;
}
