import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/main.dart';
import 'package:tcc_projeto_app/utils/text_form_field.dart';

@reflector
class PreDiagnosisModel {
  int _peso;
  int _altura;
  double _imc;
  int _pASistolica;
  int _pADiastolica;
  int _freqCardiaca;
  int _freqRepouso;
  double _temperatura;
  int _glicemia;
  String _observacao;
  DateTime _dtUltimaMestruacao;
  DateTime _dtProvavelParto;
  DateTime _dtPreDiagnosis;
  String _appointmentEventDate;

  PreDiagnosisModel({
    @required int peso,
    @required int altura,
    @required double imc,
    @required int paSistolica,
    @required int pADiastolica,
    @required int freqCardiaca,
    @required int freqRepouso,
    @required double temperatura,
    @required int glicemia,
    @required String appointmentEventDate,
    String observacao,
    DateTime dtUltimaMestruacao,
    DateTime dtProvavelParto,
    DateTime dtPreDiagnosis,
  }) {
    this._peso = peso;
    this._altura = altura;
    this._imc = imc;
    this._pASistolica = paSistolica;
    this._pADiastolica = pADiastolica;
    this._freqCardiaca = freqCardiaca;
    this._freqRepouso = freqRepouso;
    this._temperatura = temperatura;
    this._glicemia = glicemia;
    this._observacao = observacao;
    this._dtUltimaMestruacao = dtUltimaMestruacao;
    this._dtProvavelParto = dtProvavelParto;
    this._dtPreDiagnosis = dtPreDiagnosis;
    this._appointmentEventDate = appointmentEventDate;
  }

  Map<String, dynamic> toMap() {
    return {
      'peso': this._peso,
      'altura': this._altura,
      'imc': this._imc,
      'paSistolica': this._pASistolica,
      'pADiastolica': this._pADiastolica,
      'freqCardiaca': this._freqCardiaca,
      'freqRepouso': this._freqRepouso,
      'temperatura': this._temperatura,
      'glicemia': this._glicemia,
      'observacao': this._observacao,
      'ultimaMestruacao': this._dtUltimaMestruacao,
      'dtProvavelParto': this._dtProvavelParto,
      'appointmentEventDate': this._appointmentEventDate
    };
  }

  static PreDiagnosisModel fromWidgetFields(List<Widget> fields, String date) {
    var preDiagnosis = Map();
    fields.forEach((field) {
      if (field is Field) {
        switch (field.fieldPlaceholder) {
          case "PA Sistolica":
            preDiagnosis['paSistolica'] = field.textController.text;
            break;

          case "PA Diastolica":
            preDiagnosis['pADiastolica'] = field.textController.text;
            break;

          case "Peso":
            preDiagnosis['peso'] = field.textController.text;
            break;

          case "Altura":
            preDiagnosis['altura'] = field.textController.text;
            break;

          case "Temperatura":
            preDiagnosis['temperatura'] = field.textController.text;
            break;

          case "IMC":
            preDiagnosis['imc'] = field.textController.text;
            break;

          case "Glicemia":
            preDiagnosis['glicemia'] = field.textController.text;
            break;

          case "Freq Cardíaca":
            preDiagnosis['freqCardiaca'] = field.textController.text;
            break;

          case "Freq Repouso":
            preDiagnosis['freqRepouso'] = field.textController.text;
            break;

          case "Observacao":
            preDiagnosis['observacao'] = field.textController.text;
            break;
        }
      }
    });

    return PreDiagnosisModel.fromMap(preDiagnosis, date);
  }

  List<Widget> toWidgetFields() {
    return <Widget>[
      Text("Peso: ${this?.peso?.toString()}", style: TextStyle(fontSize: 17.0)),
      Text("Altura: ${this?.altura?.toString()}",
          style: TextStyle(fontSize: 17.0)),
      Text("IMC: ${this?.imc?.toString()}", style: TextStyle(fontSize: 17.0)),
      Text("Temperatura: ${this?.temperatura?.toString()}",
          style: TextStyle(fontSize: 17.0)),
      Text("PA Sistolica: ${this?.pASistolica?.toString()}",
          style: TextStyle(fontSize: 17.0)),
      Text("PA Diastolica: ${this?.pADiastolica?.toString()}",
          style: TextStyle(fontSize: 17.0)),
      Text("Glicemia : ${this?.glicemia?.toString()}",
          style: TextStyle(fontSize: 17.0)),
      Text("Freq Cardíaca: ${this?.freqCardiaca?.toString()}",
          style: TextStyle(fontSize: 17.0)),
      Text("Freq Repouso: ${this?.freqRepouso?.toString()}",
          style: TextStyle(fontSize: 17.0)),
      Text("Observacao: ${this?.observacao?.toString()}",
          style: TextStyle(fontSize: 17.0))
    ];
  }

  static PreDiagnosisModel fromMap(Map<String, dynamic> map, String key) {
    if (map == null) return null;

    int year = int.parse(key.split('/')[2]);
    int mon = int.parse(key.split('/')[1]);
    int day = int.parse(key.split('/')[0]);

    return PreDiagnosisModel(
      peso: map['peso'],
      altura: map['altura'],
      imc: map['imc'],
      paSistolica: map['paSistolica'],
      pADiastolica: map['pADiastolica'],
      freqCardiaca: map['freqCardiaca'],
      freqRepouso: map['freqRepouso'],
      temperatura: map['temperatura'],
      glicemia: map['glicemia'],
      observacao: map['observacao'],
      appointmentEventDate: map['appointmentEventDate'],
      dtPreDiagnosis: new DateTime(
        year,
        mon,
        day,
      ),
    );
  }

  int get peso => _peso;
  int get altura => _altura;
  double get imc => _imc;
  int get pASistolica => _pASistolica;
  int get pADiastolica => _pADiastolica;
  int get freqCardiaca => _freqCardiaca;
  int get freqRepouso => _freqRepouso;
  double get temperatura => _temperatura;
  int get glicemia => _glicemia;
  String get observacao => _observacao;
  DateTime get dtUltimaMestruacao => _dtUltimaMestruacao;
  DateTime get dtProvavelParto => _dtProvavelParto;
  DateTime get getPreDiagnosisDate => _dtPreDiagnosis;
  String get appointmentEventDate => _appointmentEventDate;
}
