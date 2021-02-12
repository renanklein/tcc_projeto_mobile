import 'package:tcc_projeto_app/med_record/models/diagnosis/complete_diagnosis_model.dart';
import 'package:tcc_projeto_app/med_record/models/pre_diagnosis/pre_diagnosis_model.dart';

class MedRecordModel {
  String _pacientHash;
  String _medRecordOverview;
  List<CompleteDiagnosisModel> _diagnosisModels;
  List<PreDiagnosisModel> _preDiagnosisModels;
  DateTime _createdDate;

  MedRecordModel({
    String pacientHash,
    String overview,
    List<CompleteDiagnosisModel> completeDiagnosis,
    List<PreDiagnosisModel> preDiagnosis,
    DateTime createdDate,
  }) {
    this._pacientHash = pacientHash;
    this._medRecordOverview = overview;
    this._diagnosisModels = completeDiagnosis;
    this._preDiagnosisModels = preDiagnosis;
    this._createdDate = createdDate;
  }

  Map<String, dynamic> toMap() {
    return {
      'medRecordOverview': _medRecordOverview,
    };
  }

  static MedRecordModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    List<CompleteDiagnosisModel> _diagnosisList = [];

    List<PreDiagnosisModel> _preDiagnosisList = [];

    map.keys.forEach((k) {
      if (k != 'created') {
        if (map[k]['fulldiagnosis'] != null) {
          CompleteDiagnosisModel diagnosisModel = CompleteDiagnosisModel.fromMap(map[k]['fulldiagnosis'], k);

          _diagnosisList.add(diagnosisModel);
        }

        if (map[k]['prediagnosis'] != null) {
          PreDiagnosisModel preDiagnosisModel =
              PreDiagnosisModel.fromMap(map[k]['prediagnosis'], k);

          _preDiagnosisList.add(preDiagnosisModel);
        }
      }
    });

    String data = map['created'];
    int year = int.parse(data.split('/')[2]);
    int mon = int.parse(data.split('/')[1]);
    int day = int.parse(data.split('/')[0]);

    return MedRecordModel(
      overview: map['medRecordOverview'],
      completeDiagnosis: _diagnosisList,
      preDiagnosis: _preDiagnosisList,
      createdDate: new DateTime(
        year,
        mon,
        day,
      ),
    );
  }

  String get medRecordOverview => this._medRecordOverview;
  bool get notNullPacientHash => this._pacientHash == null ? false : true;

  List<CompleteDiagnosisModel> get getDiagnosisList => this._diagnosisModels;
  List<PreDiagnosisModel> get getPreDiagnosisList => this._preDiagnosisModels;

  DateTime get getDate => this._createdDate;

  set setPacientHash(String hash) => this._pacientHash = hash;
}
