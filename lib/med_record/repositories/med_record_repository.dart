import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/med_record/models/med_record_model.dart';

class MedRecordRepository {
  final CollectionReference _MedRecordCollectionReference =
      FirebaseFirestore.instance.collection('MedRecord');

  String _userId;
  set userId(String uid) => this._userId = uid;

  Future createMedRecord({
    @required MedRecordModel medRecord,
  }) async {
    try {
      await _MedRecordCollectionReference.add(
        medRecord.toMap(),
      );
    } catch (e) {
      return e.toString();
    }
  }

  Future getmedRecordByName(String name) async {}

  Future getmedRecordList() async {}
}
