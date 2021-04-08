import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcc_projeto_app/med_record/models/diagnosis/complete_diagnosis_model.dart';
import 'package:tcc_projeto_app/med_record/models/pre_diagnosis/pre_diagnosis_model.dart';
import 'package:tcc_projeto_app/utils/dynamic_field_bottomsheet.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';
import 'package:tcc_projeto_app/utils/text_form_field.dart';

class DiagnosisTile extends StatefulWidget {
  final DateTime date;
  final List<Widget> fields;

  DiagnosisTile({@required this.date, @required this.fields});

  static List<DiagnosisTile> fromDiagnosis(
      List<CompleteDiagnosisModel> diagnosisList,
      BuildContext context,
      Function refreshDiagnosis) {
    return diagnosisList.map((diagnosis) {
      var fields = [
        Text(
          "Cid do diagnóstico: ${diagnosis?.diagnosis?.diagnosisCid}",
          style: TextStyle(fontSize: 17.0),
        ),
        Text("Descrição do problema: ${diagnosis?.problem?.problemDescription}",
            style: TextStyle(fontSize: 17.0)),
        Text(
            "Descrição do diagnóstico: ${diagnosis?.diagnosis?.diagnosisDescription}",
            style: TextStyle(fontSize: 17.0)),
        Text("Medicamento: ${diagnosis?.prescription?.prescriptionMedicine}"),
        Text(
            "Orientação de uso: ${diagnosis?.prescription?.prescriptionUsageOrientation}",
            style: TextStyle(fontSize: 17.0)),
        Text(
            "Duração de uso: ${diagnosis?.prescription?.prescriptionUsageDuration}",
            style: TextStyle(fontSize: 17.0)),
        Text("Dosagem: ${diagnosis?.prescription?.prescriptionDosageForm}",
            style: TextStyle(fontSize: 17.0)),
        Text(
            "Formulário de dosagem: ${diagnosis?.prescription?.prescriptionDosageForm}",
            style: TextStyle(fontSize: 17.0))
      ];

      diagnosis.dynamicFields.forEach((field) {
        fields.add(Text(field['placeholder'] + ": ${field['value']}",
            style: TextStyle(fontSize: 17.0)));
      });
      return DiagnosisTile(
        date: diagnosis.diagnosisDate,
        fields: [
          ...fields,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Scaffold.of(context).showBottomSheet((context) =>
                        DynamicFieldBottomSheet(
                            dynamicFieldsList: diagnosis.dynamicFields,
                            refreshForm: refreshDiagnosis));
                  })
            ],
          )
        ],
      );
    }).toList();
  }

  static List<DiagnosisTile> fromPreDiagnosisList(
      List<PreDiagnosisModel> prediagnosisList) {
    return prediagnosisList.map((preDiagnosis) {
      return DiagnosisTile(date: preDiagnosis.getPreDiagnosisDate, fields: [
        Text("PA Sistolica: ${preDiagnosis?.pASistolica?.toString()}",
            style: TextStyle(fontSize: 17.0)),
        Text("PA Diastolica: ${preDiagnosis?.pADiastolica?.toString()}",
            style: TextStyle(fontSize: 17.0)),
        Text("Peso: ${preDiagnosis?.peso?.toString()}",
            style: TextStyle(fontSize: 17.0)),
        Text("IMC: ${preDiagnosis?.imc?.toString()}",
            style: TextStyle(fontSize: 17.0)),
        Text("Glicemia : ${preDiagnosis?.glicemia?.toString()}",
            style: TextStyle(fontSize: 17.0)),
        Text("Freq Cardíaca: ${preDiagnosis?.freqCardiaca?.toString()}",
            style: TextStyle(fontSize: 17.0)),
        Text("Observacao: ${preDiagnosis?.observacao?.toString()}",
            style: TextStyle(fontSize: 17.0))
      ]);
    }).toList();
  }

  @override
  _DiagnosisTileState createState() => _DiagnosisTileState();
}

class _DiagnosisTileState extends State<DiagnosisTile> {
  DateTime get date => this.widget.date;
  List<Widget> get fields => this.widget.fields;
  List<Widget> children = <Widget>[];

  @override
  void initState() {
    this.children = [
      ...fields,
      IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            this._changeToEditMode();
          })
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var formatter = DateFormat('dd/MM/yyyy');
    var dateAsString = formatter.format(this.date);
    return Card(
      child: ExpansionTile(title: Text(dateAsString), children: this.children),
    );
  }

  void _changeToEditMode() {
    var newFields = <Widget>[];

    this.children.forEach((field) {
      if (field is Text) {
        var dataSplited = field.data.split(':');
        newFields.add(Field(
            textController: TextEditingController(text: dataSplited[0]),
            fieldPlaceholder: dataSplited[1],
            isReadOnly: false));
        newFields.add(LayoutUtils.buildVerticalSpacing(5.0));
      }
    });

    newFields.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        this._buildButton("Voltar", this._changeToReadOnlyMode),
        this._buildButton("Salvar", () {}),
      ],
    ));

    setState(() {
      this.children = newFields;
    });
  }

  void _changeToReadOnlyMode() {
    var newFields = <Widget>[];

    this.children.forEach((field) {
      if (field is Field) {
        newFields.add(
            Text("${field.fieldPlaceholder}: ${field.textController.text}"));
      }
    });
    newFields.add(IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          this._changeToEditMode();
        }));
    setState(() {
      this.children = newFields;
    });
  }

  Widget _buildButton(String text, Function onPressBehaviour) {
    return ElevatedButton(
      onPressed: () {
        onPressBehaviour();
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        primary: Theme.of(context).primaryColor,
      ),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
