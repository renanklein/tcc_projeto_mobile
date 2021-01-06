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
  }

  Map<String, dynamic> toMap() {
    return {};
  }

  static PreDiagnosisModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

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
      ultimaMestruacao: map['ultimaMestruacao'],
      dtProvavelParto: map['dtProvavelParto'],
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
}
