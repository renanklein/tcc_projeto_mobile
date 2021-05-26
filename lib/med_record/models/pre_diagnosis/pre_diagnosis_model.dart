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
  List<Map> _dynamicFields;

  PreDiagnosisModel(
      {@required int peso,
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
      List<Map> dynamicFields}) {
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
    dynamicFields == null
        ? this._dynamicFields = <Map>[]
        : this._dynamicFields = dynamicFields;
  }

  Map<String, dynamic> toMap() {
    var preDiagnosisMap = {
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

    this
        ._dynamicFields
        .forEach((element) => preDiagnosisMap.addAll(Map.from(element)));

    return preDiagnosisMap;
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

          default:
            preDiagnosis[field.fieldPlaceholder] = field.textController.text;
            break;
        }
      }
    });

    return PreDiagnosisModel.fromMap(preDiagnosis, date);
  }

  List<Widget> toWidgetFields() {
    var fields = <Widget>[
      Text("Peso: ${this?.peso?.toString()}",
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: 17.0,
          )),
      Text("Altura: ${this?.altura?.toString()}",
          textAlign: TextAlign.justify, style: TextStyle(fontSize: 17.0)),
      Text("IMC: ${this?.imc?.toString()}",
          textAlign: TextAlign.justify, style: TextStyle(fontSize: 17.0)),
      this.temperatura != null
          ? Text("Temperatura: ${this?.temperatura?.toString()}",
              textAlign: TextAlign.justify, style: TextStyle(fontSize: 17.0))
          : Container(),
      Text("PA Sistolica: ${this?.pASistolica?.toString()}",
          textAlign: TextAlign.justify, style: TextStyle(fontSize: 17.0)),
      Text("PA Diastolica: ${this?.pADiastolica?.toString()}",
          textAlign: TextAlign.justify, style: TextStyle(fontSize: 17.0)),
      this.glicemia != null
          ? Text("Glicemia: ${this?.glicemia?.toString()}",
              textAlign: TextAlign.justify, style: TextStyle(fontSize: 17.0))
          : Container(),
      Text("Freq Cardíaca: ${this?.freqCardiaca?.toString()}",
          textAlign: TextAlign.justify, style: TextStyle(fontSize: 17.0)),
      Text("Freq Repouso: ${this?.freqRepouso?.toString()}",
          textAlign: TextAlign.justify, style: TextStyle(fontSize: 17.0)),
      this.observacao.isNotEmpty
          ? Text("Observacao: ${this?.observacao?.toString()}",
              textAlign: TextAlign.justify, style: TextStyle(fontSize: 17.0))
          : Container()
    ];

    if (this._dynamicFields != null && this._dynamicFields.isNotEmpty) {
      this._dynamicFields.forEach((field) {
        if (field.keys.first != "appointmentEventDate" &&
            field.keys.first != "ultimaMestruacao" &&
            field.keys.first != "dtProvavelParto" &&
            field.keys.first != "glicemia" &&
            field.keys.first != "temperatura" &&
            field.keys.first != "observacao") {
          fields.add(Text("${field.keys.first}:${field.values.first}",
              style: TextStyle(fontSize: 17.0)));
        }
      });
    }

    return fields;
  }

  static PreDiagnosisModel fromMap(Map map, String date) {
    if (map == null) return null;

    int year = int.parse(date.split('/')[2]);
    int mon = int.parse(date.split('/')[1]);
    int day = int.parse(date.split('/')[0]);

    var temp = map.containsKey('temperatura') && map['temperatura'] != null
        ? map['temperatura']
        : "";
    var glicemia = map.containsKey('glicemia') && map['glicemia'] != null
        ? map['glicemia']
        : "";

    var prediagnosis = PreDiagnosisModel(
      peso: map['peso'] is int
          ? map.remove('peso')
          : int.parse(map.remove('peso')),
      altura: map['altura'] is int
          ? map.remove('altura')
          : int.parse(map.remove("altura")),
      imc: map['imc'] is double
          ? map.remove('imc')
          : double.parse(map.remove('imc')),
      paSistolica: map['paSistolica'] is int
          ? map.remove('paSistolica')
          : int.parse(map.remove('paSistolica')),
      pADiastolica: map['pADiastolica'] is int
          ? map.remove('pADiastolica')
          : int.parse(map.remove('pADiastolica')),
      freqCardiaca: map['freqCardiaca'] is int
          ? map.remove('freqCardiaca')
          : int.parse(map.remove('freqCardiaca')),
      freqRepouso: map['freqRepouso'] is int
          ? map.remove('freqRepouso')
          : int.parse(map.remove('freqRepouso')),
      temperatura:
          temp is double ? map.remove('temperatura') : double.tryParse(temp),
      glicemia:
          glicemia is int ? map.remove('glicemia') : int.tryParse(glicemia),
      observacao: map.remove('observacao'),
      appointmentEventDate: date,
      dtPreDiagnosis: new DateTime(
        year,
        mon,
        day,
      ),
    );

    map.entries.forEach((elem) {
      prediagnosis._dynamicFields.add({elem.key: elem.value});
    });

    return prediagnosis;
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
  List<Map> get dynamicFields => _dynamicFields;
}
