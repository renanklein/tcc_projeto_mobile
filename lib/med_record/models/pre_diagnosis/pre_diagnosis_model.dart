import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/main.dart';
import 'package:tcc_projeto_app/utils/text_form_field.dart';

class PreDiagnosisModel {
  double _peso;
  double _altura;
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
  DateTime _createdAt;
  List<Map> _dynamicFields;

  PreDiagnosisModel(
      {@required double peso,
      @required double altura,
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
      DateTime createdAt,
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
    this._createdAt = createdAt;
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
      'appointmentEventDate': this._appointmentEventDate,
      'createdAt': this._createdAt.millisecondsSinceEpoch
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
        _processField(preDiagnosis, field.fieldPlaceholder, field.textController.text);
      } else if(field is Text){
        var splitArray = field.data.split(":");
        var placeholder = splitArray[0];
        var value = splitArray[1];

        _processField(preDiagnosis, placeholder, value);
      }
    });

    return PreDiagnosisModel.fromMap(preDiagnosis, date);
  }

  static void _processField(Map preDiagnosis ,String placeholder, String value){
    switch (placeholder) {
          case "PA Sistolica":
            preDiagnosis['paSistolica'] =value;
            break;

          case "PA Diastolica":
            preDiagnosis['pADiastolica'] =value;
            break;

          case "Peso":
            preDiagnosis['peso'] =value;
            break;

          case "Altura":
            preDiagnosis['altura'] =value;
            break;

          case "Temperatura":
            preDiagnosis['temperatura'] =value;
            break;

          case "IMC":
            preDiagnosis['imc'] =value;
            break;

          case "Glicemia":
            preDiagnosis['glicemia'] =value;
            break;

          case "Freq Cardíaca":
            preDiagnosis['freqCardiaca'] =value;
            break;

          case "Freq Repouso":
            preDiagnosis['freqRepouso'] =value;
            break;

          case "Observacao":
            preDiagnosis['observacao'] =value;
            break;

          default:
            preDiagnosis[placeholder] =value;
            break;
        }
  }

  List<Widget> toWidgetFields() {
    var fields = <Widget>[
      Text(
        "Peso: ${this?.peso?.toString()}",
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize: 17.0,
        ),
      ),
      Text(
        "Altura: ${this?.altura?.toString()}",
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize: 17.0,
        ),
      ),
      Text(
        "IMC: ${this?.imc?.toStringAsFixed(2)}",
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize: 17.0,
        ),
      ),
      this.temperatura != null
          ? Text(
              "Temperatura: ${this?.temperatura?.toString()}",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 17.0,
              ),
            )
          : Container(),
      Text(
        "PA Sistolica: ${this?.pASistolica?.toString()}",
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize: 17.0,
        ),
      ),
      Text(
        "PA Diastolica: ${this?.pADiastolica?.toString()}",
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize: 17.0,
        ),
      ),
      this.glicemia != null
          ? Text(
              "Glicemia: ${this?.glicemia?.toString()}",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 17.0,
              ),
            )
          : Container(),
      Text(
        "Freq Cardíaca: ${this?.freqCardiaca?.toString()}",
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize: 17.0,
        ),
      ),
      this.freqRepouso != null
          ? Text(
              "Freq Repouso: ${this?.freqRepouso?.toString()}",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 17.0,
              ),
            )
          : Container(),
      if (this.observacao != null && this.observacao.isNotEmpty)
        Text(
          "Observacao: ${this?.observacao?.toString()}",
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: 17.0,
          ),
        )
      else
        Container()
    ];

    if (this._dynamicFields != null && this._dynamicFields.isNotEmpty) {
      this._dynamicFields.forEach((field) {
        if (field.keys.first != "appointmentEventDate" &&
            field.keys.first != "ultimaMestruacao" &&
            field.keys.first != "dtProvavelParto" &&
            field.keys.first != "glicemia" &&
            field.keys.first != "temperatura" &&
            field.keys.first != "observacao" &&
            field.keys.first != "freqRepouso") {
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

    var freqRepouso =
        map.containsKey("freqRepouso") && map["freqRepouso"] != null
            ? map["freqRepouso"]
            : "";

    var temp = map.containsKey('temperatura') && map['temperatura'] != null
        ? map['temperatura']
        : "";
    var glicemia = map.containsKey('glicemia') && map['glicemia'] != null
        ? map['glicemia']
        : "";

    if (map['peso'] is int) map['peso'] = map['peso'].toDouble();
    if (map['altura'] is int) map['altura'] = map['altura'].toDouble();

    var prediagnosis = PreDiagnosisModel(
        peso: map['peso'] is double
            ? map.remove('peso')
            : double.parse(map.remove('peso')),
        altura: map['altura'] is double
            ? map.remove('altura')
            : double.parse(map.remove("altura")),
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
        freqRepouso: freqRepouso is int
            ? map.remove("freqRepouso")
            : int.tryParse(freqRepouso),
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
        createdAt: map.containsKey("createdAt")
            ? DateTime.fromMillisecondsSinceEpoch(map.remove('createdAt'))
            : null);

    map.entries.forEach((elem) {
      prediagnosis._dynamicFields.add({elem.key: elem.value});
    });

    return prediagnosis;
  }

  double get peso => _peso;
  double get altura => _altura;
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
  DateTime get createdAt => this._createdAt;

  set createdAt(DateTime createdAt) => this._createdAt = createdAt;
}
