import 'package:flutter/material.dart';

class MedRecordModel {
  String _pacientHash;
  String _medRecordOverview;

  MedRecordModel({
    @required String pacientHash,
    @required String overview,
  }) {
    this._pacientHash = pacientHash;
    this._medRecordOverview = overview;
  }

  Map<String, dynamic> toMap() {
    return {
      'pacientHash': _pacientHash,
      'medRecordOverview': _medRecordOverview,
    };
  }

  static MedRecordModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MedRecordModel(
      pacientHash: 'teste',
      overview: map['medRecordOverview'],
    );
  }

  String get medRecordOverview => this._medRecordOverview;
  set setPacientHash(String hash) => this._pacientHash = hash;
}
