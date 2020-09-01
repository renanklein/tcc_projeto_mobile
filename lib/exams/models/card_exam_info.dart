import 'package:flutter/material.dart';

class CardExamInfo {
  final examDate;
  final examType;

  CardExamInfo({@required this.examDate, @required this.examType});

  String get getExamDate => this.examDate;
  String get getExamType => this.examType;
}
