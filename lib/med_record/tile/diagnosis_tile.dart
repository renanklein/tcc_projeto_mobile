import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reflectable/reflectable.dart';
import 'package:tcc_projeto_app/main.dart';
import 'package:tcc_projeto_app/med_record/models/pre_diagnosis/pre_diagnosis_model.dart';

class DiagnosisTile extends StatefulWidget {
  final DateTime date;
  final List<Map> fields;

  DiagnosisTile({@required this.date, @required this.fields});

  static List<DiagnosisTile> fromPreDiagnosisList(
      List<PreDiagnosisModel> prediagnosisList) {
    return prediagnosisList.map((preDiagnosis) {
      return DiagnosisTile(date: preDiagnosis.getPreDiagnosisDate, fields: [
        {
          "placeholder": "PA Sistolica",
          "value": preDiagnosis?.pASistolica?.toString()
        },
        {
          "placeholder": "PA Diastolica",
          "value": preDiagnosis?.pADiastolica?.toString()
        },
        {"placeholder": "Peso", "value": preDiagnosis?.peso?.toString()},
        {"placeholder": "IMC", "value": preDiagnosis?.imc?.toString()},
        {
          "placeholder": "Glicemia",
          "value": preDiagnosis?.glicemia?.toString(),
        },
        {
          "placeholder": "Freq Cardíaca",
          "value": preDiagnosis?.freqCardiaca?.toString(),
        },
        {
          "placeholder": "Observacao",
          "value": preDiagnosis?.observacao?.toString(),
        },
      ]);
    }).toList();
  }

  static List<DiagnosisTile> fromDiagnosisClass(List diagnosisList) {
    var date;
    var type;
    var variables;
    var tiles = diagnosisList.map((diagnosis) {
      type = reflector.reflectType(diagnosis);
      variables = type.typeVariables;
      print(type.toString());
      _fromClassFields(variables);
    });

    return <DiagnosisTile>[];
  }

  static List<Map> _fromClassFields(List<TypeVariableMirror> variables) {
    variables.forEach((element) {
      print(element.toString());
    });
  }

  @override
  _DiagnosisTileState createState() => _DiagnosisTileState();
}

class _DiagnosisTileState extends State<DiagnosisTile> {
  DateTime get date => this.widget.date;
  List<Map> get fields => this.widget.fields;

  @override
  Widget build(BuildContext context) {
    var formatter = DateFormat('dd/MM/yyyy');
    var dateAsString = formatter.format(this.date);
    return ExpansionTile(
      title: Text(dateAsString),
      children: _buildDiagnosisFields(),
    );
  }

  List<Widget> _buildDiagnosisFields() {
    return this.fields.map((field) => DiagnosisField(field: field)).toList();
  }
}

class DiagnosisField extends StatelessWidget {
  final Map field;
  DiagnosisField({@required this.field});
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController(
        text: "${this.field['placeholder']} : ${this.field['value']}");
    return TextField(
      readOnly: true,
      controller: controller,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 20.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
  }
}
