import 'package:flutter/material.dart';

class UserModel{
  String _email;
  String _name;

  UserModel({@required String email, @required String name}){
    this._email = email;
    this._name = name;
  }

  String get email => this._email;
  String get name => this._name;
}