import 'package:flutter/material.dart';

class PreDiagnosisModel {
  int _peso;
  int _altura;
  double _imc;
  int _paSistolica;
  int _pADiastolica;
  int _freqCardiaca;
  int _freqRepouso;
  double _temperatura;
  int _glicemia;
  String _observacao;
  DateTime _ultimaMestruacao;
  DateTime _dtProvavelParto;
  DateTime _preDiagnosisDate;

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
    @required DateTime dtPreDiagnosis,
    String observacao,
    DateTime ultimaMestruacao,
    DateTime dtProvavelParto,
  }) {
    this._peso = peso;
    this._altura = altura;
    this._imc = imc;
    this._paSistolica = paSistolica;
    this._pADiastolica = pADiastolica;
    this._freqCardiaca = freqCardiaca;
    this._freqRepouso = freqRepouso;
    this._temperatura = temperatura;
    this._glicemia = glicemia;
    this._observacao = observacao;
    this._ultimaMestruacao = ultimaMestruacao;
    this._dtProvavelParto = dtProvavelParto;
    this._preDiagnosisDate = dtPreDiagnosis;
  }

  Map<String, dynamic> toMap() {
    return {};
  }

  static PreDiagnosisModel fromMap(Map<String, dynamic> map, String key) {
    if (map == null) return null;

    int year = int.parse(key.split('/')[2]);
    int mon = int.parse(key.split('/')[1]);
    int day = int.parse(key.split('/')[0]);

    var dtUltimaMestruacao = map['ultimaMestruacao'] ?? '';
    var dtProvavelParto = map['dtProvavelParto'] ?? '';

    PreDiagnosisModel preDiagnosisModel = new PreDiagnosisModel(
      peso: map['peso'],
      altura: map['altura'],
      imc: map['imc'],
      paSistolica: map['paSistolica'],
      pADiastolica: map['pADiastolica'],
      freqCardiaca: map['freqCardiaca'],
      freqRepouso: map['freqRepouso'],
      temperatura: map['temperatura'],
      glicemia: map['glicemia'],
      dtPreDiagnosis: new DateTime(
        year,
        mon,
        day,
      ),
    );

    preDiagnosisModel.setDtProvavelParto = dtProvavelParto;
    preDiagnosisModel.setDtUltimaMestruacao = dtUltimaMestruacao;

    return preDiagnosisModel;

    /* PreDiagnosisModel(
      peso: map['peso'],
      altura: map['altura'],
      imc: map['imc'],
      paSistolica: map['paSistolica'],
      pADiastolica: map['pADiastolica'],
      freqCardiaca: map['freqCardiaca'],
      freqRepouso: map['freqRepouso'],
      temperatura: map['temperatura'],
      glicemia: map['glicemia'],
      ultimaMestruacao: (map['ultimaMestruacao'] != null)
          ? new DateTime(
              int.parse(map['ultimaMestruacao'].split('/')[2]),
              int.parse(map['ultimaMestruacao'].split('/')[1]),
              int.parse(map['ultimaMestruacao'].split('/')[0]),
            )
          : null,
      dtProvavelParto: (map['dtProvavelParto'] != null)
          ? new DateTime(
              int.parse(map['dtProvavelParto'].split('/')[2]),
              int.parse(map['dtProvavelParto'].split('/')[1]),
              int.parse(map['dtProvavelParto'].split('/')[0]),
            )
          : null,
      dtPreDiagnosis: new DateTime(
        year,
        mon,
        day,
      ),
    ); */
  }

  int get peso => _peso;
  int get altura => _altura;
  double get imc => _imc;
  int get paSistolica => _paSistolica;
  int get pADiastolica => _pADiastolica;
  int get freqCardiaca => _freqCardiaca;
  int get freqRepouso => _freqRepouso;
  double get temperatura => _temperatura;
  int get glicemia => _glicemia;
  String get observacao => _observacao;
  DateTime get ultimaMestruacao => _ultimaMestruacao;
  DateTime get dtProvavelParto => _dtProvavelParto;
  DateTime get getPreDiagnosisDate => _preDiagnosisDate;

  set setDtUltimaMestruacao(String date) {
    if (date != '') {
      var dt = new DateTime(
        int.parse(date.split('/')[2]),
        int.parse(date.split('/')[1]),
        int.parse(date.split('/')[0]),
      );
      this._ultimaMestruacao = dt;
    }
  }

  set setDtProvavelParto(String date) {
    if (date != '') {
      var dt = new DateTime(
        int.parse(date.split('/')[2]),
        int.parse(date.split('/')[1]),
        int.parse(date.split('/')[0]),
      );
      this._dtProvavelParto = dt;
    }
  }
}
