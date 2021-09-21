import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/med_record/models/diagnosis/diagnosis_model.dart';
import 'package:tcc_projeto_app/med_record/models/diagnosis/problem_model.dart';
import 'package:tcc_projeto_app/utils/text_form_field.dart';


class CompleteDiagnosisModel {
  ProblemModel _problemModel;
  DiagnosisModel _diagnosisModel;
  String _prescriptionModel;
  DateTime _diagnosisDate;
  List<Map> _dynamicFields;
  DateTime _createdAt;
  int _id;

  CompleteDiagnosisModel(
      {@required ProblemModel problem,
      @required DiagnosisModel diagnosis,
      String prescription,
      DateTime date,
      List<Map> dynamicFields,
      DateTime createdAt,
      int id}) {
    this._problemModel = problem;
    this._diagnosisModel = diagnosis;
    this._prescriptionModel = prescription;
    this._diagnosisDate = date;
    this._createdAt = createdAt;
    dynamicFields == null
        ? this._dynamicFields = <Map>[]
        : this._dynamicFields = dynamicFields;
    this._id = id;
  }

  Map<String, dynamic> toMap() {
    var diagnosis = {
      'problem': _problemModel.toMap(),
      'diagnosis': _diagnosisModel.toMap(),
      'prescription': _prescriptionModel,
      'createdAt' : this._createdAt.millisecondsSinceEpoch,
      'id': this.id,
    };

    this
        .dynamicFields
        .forEach((element) => diagnosis.addAll(Map.from(element)));
    return diagnosis;
  }

  static CompleteDiagnosisModel fromWidgetFields(
      List<Widget> fields, String date) {
    var diagnosisCompleteMap = Map();
    var problemMap = Map();
    var diagnosisMap = Map.from({
      'id' : "",
      'description': ""
    });

    fields.forEach((field) {
      if (field is Field || field is Text) {
        String placeholder = "";

        if (field is Field) {
          placeholder = field.fieldPlaceholder;
        } else if (field is Text) {
          placeholder = field.data.split(":")[0];
        }

        String value = "";

        if (field is Field) {
          value = field.textController.text;
        } else if (field is Text) {
          value = field.data.split(":")[1];
        }
        var value2 = value;
        switch (placeholder) {
          case "Cid do diagnóstico":
            diagnosisMap['id'] += value2 + ";";
            break;

          case "Descrição do diagnóstico":
            diagnosisMap['description'] += value + ";";
            break;

          case "Descrição do problema":
            problemMap['description'] = value;
            break;

          case "Prescrição":
            diagnosisCompleteMap["prescription"] = value;
            break;

          default:
            diagnosisCompleteMap[placeholder] = value;
        }
      }
    });

    diagnosisCompleteMap['problem'] = problemMap;
    diagnosisCompleteMap['diagnosis'] = diagnosisMap;

    return CompleteDiagnosisModel.fromList([diagnosisCompleteMap], date).first;
  }

  List<Widget> toWidgetFields() {
    var fields = <Widget>[
      Text(
        "Descrição do problema:${this?.problem?.problemDescription}",
        textAlign: TextAlign.justify,
        style: TextStyle(fontSize: 14.0),
      ),
      Text(
        "Prescrição:${this?.prescription}",
        style: TextStyle(fontSize: 14.0),
      ),
    ];

    for(int i = 0; i < this?.diagnosis?.diagnosisCid?.length; i++){
      fields.add(Text(
        "Cid do diagnóstico: ${this?.diagnosis?.diagnosisCid[i]}",
        textAlign: TextAlign.justify,
        style: TextStyle(fontSize: 14.0),
      ));
      fields.add( Text(
        "Descrição do diagnóstico:${this?.diagnosis?.diagnosisDescription[i]}",
        textAlign: TextAlign.justify,
        style: TextStyle(fontSize: 14.0),
      ));
    }


    if (this.dynamicFields != null && this.dynamicFields.isNotEmpty) {
      this.dynamicFields.forEach((field) {
        if (field.keys.first != "id" && field.keys.first != "createdAt") {
          fields.add(Text("${field.keys.first}:${field.values.first}",
          textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14.0)));
        }
      });
    }

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
          prescription: map['prescription'],
          date: DateTime(
            year,
            mon,
            day,
          ),
          createdAt: map.containsKey("createdAt") ? DateTime.fromMillisecondsSinceEpoch(map.remove("createdAt") ): null,
          id: map['id']);

      map.forEach((key, value) {
        if (key != 'problem' && key != 'diagnosis' && key != 'prescription') {
          completeDiagnosis.dynamicFields.add({key: value});
        }
      });

      return completeDiagnosis;
    }).toList();
  }

  DateTime get getDate => this._diagnosisDate;
  set setDate(DateTime dt) => this._diagnosisDate = dt;

  ProblemModel get problem => this._problemModel;
  DiagnosisModel get diagnosis => this._diagnosisModel;
  String get prescription => this._prescriptionModel;
  DateTime get diagnosisDate => this._diagnosisDate;
  List<Map> get dynamicFields => this._dynamicFields;
  DateTime get createdAt => this._createdAt;

  int get id => this._id;
  set setId(int id) => this._id = id;
  set createdAt(DateTime createdAt) => this._createdAt = createdAt;
}
