import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/main.dart';


class ProblemModel {
  String _description;
  String _problemId;

  ProblemModel({
    @required String description,
    @required String problemId,
  }) {
    this._description = description;
    this._problemId = problemId;
  }

  Map<String, dynamic> toMap() {
    return {
      'description': _description,
      'id': _problemId,
    };
  }

  static ProblemModel fromMap(Map map) {
    if (map == null) return null;

    return ProblemModel(
      description: map['description'],
      problemId: map['id'],
    );
  }

  String get problemDescription => this._description;
  String get problemId => this._problemId;
}
