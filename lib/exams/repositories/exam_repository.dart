import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tcc_projeto_app/exams/models/card_exam_info.dart';
import 'package:tcc_projeto_app/exams/models/exam_details.dart';

class ExamRepository {
  final _firestore = Firestore.instance;

  //TODO: Alterar esse método depois !!!!!!!!!!!!!!!!!!!!!!
  Future saveExam(CardExamInfo cardExamInfo, ExamDetails examDetails,
      String filePath) async {
    var user = await _getUser();

    await this._firestore.collection("exams").document(user.uid).setData({
      "filePath": filePath,
      "examDate": cardExamInfo.getExamDate,
      "examType": cardExamInfo.getExamType,
      "pacientName": examDetails.getPacientName,
      "examinationUnit": examDetails.getExaminationUnit,
      "requestingDoctor": examDetails.getRequestingDoctor,
      "examResponsible": examDetails.getExamResponsable,
      "examDescription": examDetails.getExamDescription,
      "diagnosticHypothesis": examDetails.getDiagnosticHypothesis,
      "otherPacientInformation": examDetails.getOtherPacientInformation
    });
  }

  //TODO: Alterar esse método depois !!!!!!!!!!!!!!!!!!!!!!
  Future<List> getExam() async {
    var user = await _getUser();

    var examSnapshot =
        await this._firestore.collection("exams").document(user.uid).get();

    return [
      CardExamInfo(
          examDate: examSnapshot.data["examDate"],
          examType: examSnapshot.data["examType"]),
      ExamDetails(
          pacientName: examSnapshot.data["pacientName"],
          examinationUnit: examSnapshot.data["examinationUnit"],
          requestingDoctor: examSnapshot.data["requestingDoctor"],
          examResponsable: examSnapshot.data["examResponsable"],
          examDate: examSnapshot.data["examDate"],
          examDescription: examSnapshot.data["examDescription"],
          diagnosticHypothesis: examSnapshot.data["diagnosticHypothesis"],
          otherPacientInformation:
              examSnapshot.data["otherPacientInformation"]),
      examSnapshot.data["filePath"]
    ];
  }

  Future<FirebaseUser> _getUser() async {
    return await FirebaseAuth.instance.currentUser();
  }
}
