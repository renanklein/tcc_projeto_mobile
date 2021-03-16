import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/pacient/models/pacient_model.dart';

class CreatePreDiagnosisArguments {
  final PacientModel pacientModel;
  final DateTime appointmentEventDate;
  CreatePreDiagnosisArguments(
      {@required this.pacientModel, @required this.appointmentEventDate});
}
