import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/main.dart';
import 'package:tcc_projeto_app/med_record/models/diagnosis/diagnosis_model.dart';
import 'package:tcc_projeto_app/med_record/models/diagnosis/prescription_model.dart';
import 'package:tcc_projeto_app/med_record/models/diagnosis/problem_model.dart';
import 'package:tcc_projeto_app/utils/text_form_field.dart';

@reflector
class CompleteDiagnosisModel {
  ProblemModel _problemModel;
  DiagnosisModel _diagnosisModel;
  PrescriptionModel _prescriptionModel;
  DateTime _diagnosisDate;
  List<Map> _dynamicFields;
  int _id;

  CompleteDiagnosisModel(
      {@required ProblemModel problem,
      @required DiagnosisModel diagnosis,
      PrescriptionModel prescription,
      DateTime date,
      int id}) {
    this._problemModel = problem;
    this._diagnosisModel = diagnosis;
    this._prescriptionModel = prescription;
    this._diagnosisDate = date;
    this._dynamicFields = <Map>[];
    this._id = id;
  }

  Map<String, dynamic> toMap() {
    return {
      'problem': _problemModel.toMap(),
      'diagnosis': _diagnosisModel.toMap(),
      'prescription': _prescriptionModel.toMap(),
      'id': this.id
    };
  }

  static CompleteDiagnosisModel fromWidgetFields(
      List<Widget> fields, String date) {
    var diagnosisCompleteMap = Map();
    var problemMap = Map();
    var prescriptionMap = Map();
    var diagnosisMap = Map();

    fields.forEach((field) {
      if (field is Field) {
        switch (field.fieldPlaceholder) {
          case "Cid do diagnóstico":
            diagnosisMap['cid'] = field.textController.text;
            break;

          case "Descrição do diagnóstico":
            diagnosisMap['description'] = field.textController.text;
            break;

          case "Descrição do problema":
            problemMap['description'] = field.textController.text;
            break;

          case "Medicamento":
            prescriptionMap['medicine'] = field.textController.text;
            break;

          case "Orientação de uso":
            prescriptionMap['usage'] = field.textController.text;
            break;

          case "Duração de uso":
            prescriptionMap['duration'] = field.textController.text;
            break;

          case "Dosagem":
            prescriptionMap['dosage'] = field.textController.text;
            break;

          case "Formulário de dosagem":
            prescriptionMap['dosageForm'] = field.textController.text;
            break;

          default:
            diagnosisCompleteMap[field.fieldPlaceholder] =
                field.textController.text;
        }
      }
    });

    diagnosisCompleteMap['problem'] = problemMap;
    diagnosisCompleteMap['diagnosis'] = diagnosisMap;
    diagnosisCompleteMap['prescription'] = prescriptionMap;

    return CompleteDiagnosisModel.fromList([diagnosisCompleteMap], date).first;
  }

  List<Widget> toWidgetFields() {
    var fields = <Widget>[
      Text(
        "Cid do diagnóstico: ${this?.diagnosis?.diagnosisCid}",
        style: TextStyle(fontSize: 17.0),
      ),
      Text("Descrição do problema: ${this?.problem?.problemDescription}",
          style: TextStyle(fontSize: 17.0)),
      Text("Descrição do diagnóstico: ${this?.diagnosis?.diagnosisDescription}",
          style: TextStyle(fontSize: 17.0)),
      Text("Medicamento: ${this?.prescription?.prescriptionMedicine}"),
      Text(
          "Orientação de uso: ${this?.prescription?.prescriptionUsageOrientation}",
          style: TextStyle(fontSize: 17.0)),
      Text("Duração de uso: ${this?.prescription?.prescriptionUsageDuration}",
          style: TextStyle(fontSize: 17.0)),
      Text("Dosagem: ${this?.prescription?.prescriptionDosageForm}",
          style: TextStyle(fontSize: 17.0)),
      Text(
          "Formulário de dosagem: ${this?.prescription?.prescriptionDosageForm}",
          style: TextStyle(fontSize: 17.0))
    ];

    this.dynamicFields.forEach((field) {
      fields.add(Text(field['placeholder'] + ": ${field['value']}",
          style: TextStyle(fontSize: 17.0)));
    });

    return fields;
  }

  static List<CompleteDiagnosisModel> fromList(List diagnosisList, String key) {
    return diagnosisList.map((map) {
      if (map == null || map.length < 2) return null;

      int year = int.parse(key.split('/')[2]);
      int mon = int.parse(key.split('/')[1]);
      int day = int.parse(key.split('/')[0]);

      var completeDiagnosis = CompleteDiagnosisModel(
          problem: ProblemModel.fromMap(map['problem']),
          diagnosis: DiagnosisModel.fromMap(map['diagnosis']),
          prescription: PrescriptionModel.fromMap(map['prescription']),
          date: new DateTime(
            year,
            mon,
            day,
          ),
          id: map['id']);

      map.remove('problem');
      map.remove('diagnosis');
      map.remove("prescription");
      map.remove('id');

      map.forEach((key, value) {
        completeDiagnosis.dynamicFields.add({key: value});
      });
    }).toList();
  }

  DateTime get getDate => this._diagnosisDate;
  set setDate(DateTime dt) => this._diagnosisDate = dt;

  ProblemModel get problem => this._problemModel;
  DiagnosisModel get diagnosis => this._diagnosisModel;
  PrescriptionModel get prescription => this._prescriptionModel;
  DateTime get diagnosisDate => this._diagnosisDate;
  List<Map> get dynamicFields => this._dynamicFields;
  int get id => this._id;
}
