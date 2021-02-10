import 'package:flutter/material.dart';

class DiagnosisModel {
  String _description;
  String _cid;

  DiagnosisModel({
    @required String description,
    @required String cid,
  }) {
    this._description = description;
    this._cid = cid;
  }

  Map<String, dynamic> toMap() {
    return {
      'description': _description,
      'id': _cid,
    };
  }

  static DiagnosisModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return DiagnosisModel(
      description: map['description'],
      cid: map['id'],
    );
  }

  String get diagnosisDescription => this._description;
  String get diagnosisCid => this._cid;
}
