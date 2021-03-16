part of 'med_record_bloc.dart';

class PreDiagnosisCreateButtonPressed extends MedRecordEvent {
  final peso;
  final altura;
  final imc;
  final pASistolica;
  final pADiastolica;
  final freqCardiaca;
  final freqRepouso;
  final temperatura;
  final glicemia;
  final obs;
  final dtUltimaMestruacao;
  final dtProvavelParto;
  final dtAppointmentEvent;

  PreDiagnosisCreateButtonPressed(
      {@required this.peso,
      @required this.altura,
      @required this.imc,
      @required this.pASistolica,
      @required this.pADiastolica,
      @required this.freqCardiaca,
      @required this.freqRepouso,
      @required this.temperatura,
      @required this.glicemia,
      this.obs,
      this.dtUltimaMestruacao,
      this.dtProvavelParto,
      @required this.dtAppointmentEvent});

  @override
  List<Object> get props => [];
}

class GetPreDiagnosis extends MedRecordEvent {
  @override
  List<Object> get props => [];
}
