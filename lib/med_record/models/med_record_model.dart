import 'package:flutter/material.dart';

class MedRecordModel {
  String _pacientHash;

  MedRecordModel({
    @required String pacientHash,
  }) {
    this._pacientHash = pacientHash;
  }

  Map<String, dynamic> toMap() {
    return {
      'pacientHash': _pacientHash,
    };
  }

  static MedRecordModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MedRecordModel(
      pacientHash: 'teste',
    );
  }

  //String get email => this._email;
  //set userUid(String uid) => this._userId = uid;
}
