import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/pacient/models/pacient_model.dart';

class PacientRepository extends ChangeNotifier {
  final CollectionReference _pacientsCollectionReference =
      Firestore.instance.collection('pacients');

  List<PacientModel> _pacients;
  List<PacientModel> get pacientsList => _pacients;

  //String _userId;
  //set userId(String uid) => this._userId = uid;

  final StreamController<List<PacientModel>> _pacientsController =
      StreamController<List<PacientModel>>.broadcast();

  Future createPacient({
    @required PacientModel pacient,
  }) async {
    try {
      await _pacientsCollectionReference.add(
        pacient.toMap(),
      );
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
  }

  Future getPacientByName(String name) async {}

  void listenToPacients() {
    listenToPacientsRealTime().listen((pacientsData) {
      List<PacientModel> updatedPacients = pacientsData;
      if (updatedPacients != null && updatedPacients.length > 0) {
        _pacients = updatedPacients;
        notifyListeners();
      }
    });
  }

  Stream listenToPacientsRealTime() {
    _pacientsCollectionReference.snapshots().listen((pacientsSnapshot) {
      if (pacientsSnapshot.documents.isNotEmpty) {
        var pacients = pacientsSnapshot.documents
            .map((snapshot) => PacientModel.fromMap(snapshot.data))
            .where((mappedItem) => mappedItem.nome != null)
            .toList();

        _pacientsController.add(pacients);
        notifyListeners();
      }
    });

    return _pacientsController.stream;
  }
}
