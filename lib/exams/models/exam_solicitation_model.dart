import 'package:flutter/material.dart';

class ExamSolicitationModel {
  String examTypeModel;
  String solicitationDate;
  String status;
  String id;

  ExamSolicitationModel(
      {@required this.examTypeModel,
      @required this.solicitationDate,
      @required this.id,
      @required this.status});

  static Map<String, dynamic> toMap(
      ExamSolicitationModel examSolicitationModel) {
    return {
      "id": examSolicitationModel.id,
      "status": examSolicitationModel.status,
      "examTypeModel": examSolicitationModel.examTypeModel,
      "solicitationDate": examSolicitationModel.solicitationDate
    };
  }

  static ExamSolicitationModel fromMap(
      Map examSolicitation, String examSolicitationId) {
    if (examSolicitation == null) return null;
    return ExamSolicitationModel(
        id: examSolicitationId,
        status: examSolicitation["status"],
        examTypeModel: examSolicitation["examTypeModel"],
        solicitationDate: examSolicitation["solicitationDate"]);
  }
}
