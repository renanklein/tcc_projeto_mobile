import 'package:flutter/material.dart';

class MedRecordModel {
  //final _nome;

  MedRecordModel(
      //@required final userId,
      ) {
    //this._userId = userId;
  }

  Map<String, dynamic> toMap() {
    return {
      //'userId': _userId,
    };
  }

  static MedRecordModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MedRecordModel(
        //userId: map['userId'],

        );
  }

  //String get email => this._email;
  //set userUid(String uid) => this._userId = uid;
}
