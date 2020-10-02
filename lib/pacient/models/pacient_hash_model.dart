import 'package:flutter/material.dart';

class PacientHashModel {
  String _pacientHash;
  String _salt;

  PacientHashModel({
    @required String hash,
    @required String salt,
  }) {
    this._pacientHash = hash;
    this._salt = salt;
  }

  Map<String, dynamic> toMap() {
    return {
      'pacientHash': _pacientHash,
      'salt': _salt,
    };
  }

  String get pacientHash => this._pacientHash;
  String get salt => this._salt;
}
