import 'package:flutter/material.dart';

class PrescriptionModel {
  //static int _mDID;
  String _medicine;
  String _dosage;
  String _dosageForm;
  String _usage;
  String _duration;
  String _date;

  PrescriptionModel({
    @required String medicine,
    @required String dosage,
    @required String dosageForm,
    @required String usage,
    @required String duration,
    @required String date,
  }) {
    this._medicine = medicine;
    this._dosage = dosage;
    this._dosageForm = dosageForm;
    this._usage = usage;
    this._duration = duration;
    this._date = date;
  }

  Map<String, dynamic> toMap() {
    return {
      'medicine': _medicine,
      'dosage': _dosage,
      'dosageForm': _dosageForm,
      'usage': _usage,
      'duration': _duration,
      'date': _date,
    };
  }

  static PrescriptionModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return PrescriptionModel(
      medicine: map['medicine'],
      dosage: map['dosage'],
      dosageForm: map['dosageForm'],
      usage: map['usage'],
      duration: map['duration'],
      date: map['date'],
    );
  }

  //String get email => this._email;
  //set userUid(String uid) => this._userId = uid;
}
