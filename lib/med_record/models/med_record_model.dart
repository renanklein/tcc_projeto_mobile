import 'package:tcc_projeto_app/med_record/models/diagnosis/complete_diagnosis_model.dart';

class MedRecordModel {
  String _pacientHash;
  String _medRecordOverview;
  List<CompleteDiagnosisModel> _diagnosisModels;
  DateTime _createdDate;

  MedRecordModel({
    String pacientHash,
    String overview,
    List<CompleteDiagnosisModel> completeDiagnosis,
    DateTime createdDate,
  }) {
    this._pacientHash = pacientHash;
    this._medRecordOverview = overview;
    this._diagnosisModels = completeDiagnosis;
    this._createdDate = createdDate;
  }

  Map<String, dynamic> toMap() {
    return {
      'medRecordOverview': _medRecordOverview,
    };
  }

  static MedRecordModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    List<CompleteDiagnosisModel> _diagnosisList =
        new List<CompleteDiagnosisModel>();

    map.keys.forEach((k) {
      if (k != 'created') {
        CompleteDiagnosisModel diagnosisModel =
            CompleteDiagnosisModel.fromMap(map[k], k);
        _diagnosisList.add(diagnosisModel);
      }
    });

    String data = map['created'];
    int year = int.parse(data.split('/')[2]);
    int mon = int.parse(data.split('/')[1]);
    int day = int.parse(data.split('/')[0]);

    return MedRecordModel(
      overview: map['medRecordOverview'],
      completeDiagnosis: _diagnosisList,
      createdDate: new DateTime(
        year,
        mon,
        day,
      ),
    );
  }

  String get medRecordOverview => this._medRecordOverview;
  bool get notNullPacientHash => this._pacientHash == null ? false : true;

  DateTime get getDate => this._createdDate;

  set setPacientHash(String hash) => this._pacientHash = hash;
}
