import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExamRepository {
  final _firestore = Firestore.instance;

  //TODO: Alterar esse método depois !!!!!!!!!!!!!!!!!!!!!!
  Future saveExam(String pacientName, String filePath, String fileName) async {
    var user = await _getUser();

    await this._firestore.collection("exams").document(user.uid).setData(
        {"pacient": pacientName, "filePath": filePath, "fileName": fileName});
  }

  //TODO: Alterar esse método depois !!!!!!!!!!!!!!!!!!!!!!
  Future<Map> getExam() async {
    var user = await _getUser();
    Map exam = Map();

    await this
        ._firestore
        .collection("exams")
        .document(user.uid)
        .get()
        .then((value) => exam = value.data);

    return exam;
  }

  Future<FirebaseUser> _getUser() async {
    return await FirebaseAuth.instance.currentUser();
  }
}
