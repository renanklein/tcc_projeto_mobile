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
  DateTime _dtPreDiagnosis;

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
    String observacao,
    DateTime dtUltimaMestruacao,
    DateTime dtProvavelParto,
    DateTime dtPreDiagnosis,
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
    this._dtPreDiagnosis = dtPreDiagnosis;
  }

  Map<String, dynamic> toMap() {
    return {
      'peso': this._peso,
      'altura': this._altura,
      'imc': this._imc,
      'paSistolica': this._paSistolica,
      'pADiastolica': this._pADiastolica,
      'freqCardiaca': this._freqCardiaca,
      'freqRepouso': this._freqRepouso,
      'temperatura': this._temperatura,
      'glicemia': this._glicemia,
      'observacao': this._observacao,
      'ultimaMestruacao': this._ultimaMestruacao,
      'dtProvavelParto': this._dtProvavelParto,
    };
  }

  static PreDiagnosisModel fromMap(Map<String, dynamic> map, String key) {
    if (map == null) return null;

    int year = int.parse(key.split('/')[2]);
    int mon = int.parse(key.split('/')[1]);
    int day = int.parse(key.split('/')[0]);

    return PreDiagnosisModel(
      peso: int.parse(map['peso']),
      altura: int.parse(map['altura']),
      imc: double.parse(map['imc']),
      paSistolica: int.parse(map['paSistolica']),
      pADiastolica: int.parse(map['pADiastolica']),
      freqCardiaca: int.parse(map['freqCardiaca']),
      freqRepouso: int.parse(map['freqRepouso']),
      temperatura: double.parse(map['temperatura']),
      glicemia: int.parse(map['glicemia']),
      dtUltimaMestruacao: new DateTime(
        int.parse(map['ultimaMestruacao'].toString().split('/')[2]),
        int.parse(map['ultimaMestruacao'].toString().split('/')[1]),
        int.parse(map['ultimaMestruacao'].toString().split('/')[0]),
      ),
      dtProvavelParto: new DateTime(
        int.parse(map['dtProvavelParto'].toString().split('/')[2]),
        int.parse(map['dtProvavelParto'].toString().split('/')[1]),
        int.parse(map['dtProvavelParto'].toString().split('/')[0]),
      ),
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
  int get paSistolica => _paSistolica;
  int get pADiastolica => _pADiastolica;
  int get freqCardiaca => _freqCardiaca;
  int get freqRepouso => _freqRepouso;
  double get temperatura => _temperatura;
  int get glicemia => _glicemia;
  String get observacao => _observacao;
  DateTime get ultimaMestruacao => _ultimaMestruacao;
  DateTime get dtProvavelParto => _dtProvavelParto;
  DateTime get getPreDiagnosisDate => _dtPreDiagnosis;
}
