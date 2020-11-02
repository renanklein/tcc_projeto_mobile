import 'package:tcc_projeto_app/med_record/models/diagnosis/complete_diagnosis_model.dart';

class MedRecordModel {
  String _pacientHash;
  String _medRecordOverview;
  CompleteDiagnosisModel diagnosisModel;

  MedRecordModel({
    String pacientHash,
    String overview,
    CompleteDiagnosisModel completeDiagnosis,
  }) {
    this._pacientHash = pacientHash;
    this._medRecordOverview = overview;
    this.diagnosisModel = diagnosisModel;
  }

  Map<String, dynamic> toMap() {
    return {
      'medRecordOverview': _medRecordOverview,
    };
  }

  static MedRecordModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MedRecordModel(
      overview: map['medRecordOverview'],
      completeDiagnosis: CompleteDiagnosisModel.fromMap(map),
    );
  }

  String get medRecordOverview => this._medRecordOverview;
  bool get notNullPacientHash => this._pacientHash == null ? false : true;

  set setPacientHash(String hash) => this._pacientHash = hash;
}
