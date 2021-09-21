import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/main.dart';


class DiagnosisModel {
  List<String> _descriptionList;
  List<String> _cidList;

  DiagnosisModel({
    @required List<String> descriptionList,
    @required List<String> cidList,
  }) {
    this._descriptionList = descriptionList;
    this._cidList = cidList;
  }

  Map<String, dynamic> toMap() {
    var _description = '';
    var _cid = '';

    for (int i = 0; i < _descriptionList.length; i++) {
      _description += _descriptionList[i] + ';';
      _cid += _cidList[i] + ';';
    }

    return {
      'description': _description,
      'id': _cid,
    };
  }

  static DiagnosisModel fromMap(Map map) {
    if (map == null) return null;

    var diagnosisModel = DiagnosisModel(
      descriptionList: map['description'].split(';'),
      cidList: map['id'].split(';'),
    );

    diagnosisModel.diagnosisCid.remove("");
    diagnosisModel.diagnosisDescription.remove("");

    return diagnosisModel;
  }

  List<String> get diagnosisDescription => this._descriptionList;
  List<String> get diagnosisCid => this._cidList;
}
