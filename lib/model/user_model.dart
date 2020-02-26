import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model{
  String _email;
  String _name;

  UserModel({@required String email, @required String name}){
    this._email = email;
    this._name = name;
  }

  String get email => this._email;
  String get name => this._name;
}