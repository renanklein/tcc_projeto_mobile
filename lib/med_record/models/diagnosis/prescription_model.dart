import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/main.dart';


class PrescriptionModel {
  //static int _mDID;
  String _prescription;

  PrescriptionModel({@required String prescription}) {
    this._prescription = prescription;
  }

  Map<String, dynamic> toMap() {
    return {
      'prescription': _prescription,
    };
  }

  static PrescriptionModel fromMap(Map map) {
    if (map == null) return null;

    return PrescriptionModel(
      prescription: map['prescription'],
    );
  }

  String get prescription => this._prescription;
}
