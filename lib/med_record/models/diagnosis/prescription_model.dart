import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/main.dart';

@reflector
class PrescriptionModel {
  //static int _mDID;
  String _medicine;
  String _dosage;
  String _dosageForm;
  String _usageOrientation;
  String _usageDuration;

  PrescriptionModel({
    @required String medicine,
    @required String dosage,
    @required String dosageForm,
    @required String usageOrientation,
    @required String usageDuration,
  }) {
    this._medicine = medicine;
    this._dosage = dosage;
    this._dosageForm = dosageForm;
    this._usageOrientation = usageOrientation;
    this._usageDuration = usageDuration;
  }

  Map<String, dynamic> toMap() {
    return {
      'medicine': _medicine,
      'dosage': _dosage,
      'dosageForm': _dosageForm,
      'usage': _usageOrientation,
      'duration': _usageDuration,
    };
  }

  static PrescriptionModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return PrescriptionModel(
      medicine: map['medicine'],
      dosage: map['dosage'],
      dosageForm: map['dosageForm'],
      usageOrientation: map['usage'],
      usageDuration: map['duration'],
    );
  }

  String get prescriptionMedicine => this._medicine;
  String get prescriptionDosage => this._dosage;
  String get prescriptionDosageForm => this._dosageForm;
  String get prescriptionUsageOrientation => this._usageOrientation;
  String get prescriptionUsageDuration => this._usageDuration;
}
