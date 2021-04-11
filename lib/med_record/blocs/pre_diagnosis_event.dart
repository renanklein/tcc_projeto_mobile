part of 'med_record_bloc.dart';

class PreDiagnosisCreateOrUpdateButtonPressed extends MedRecordEvent {
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

  PreDiagnosisCreateOrUpdateButtonPressed(
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

  static PreDiagnosisCreateOrUpdateButtonPressed fromModel(
      PreDiagnosisModel preDiagnosis) {
    return PreDiagnosisCreateOrUpdateButtonPressed(
        peso: preDiagnosis.peso,
        altura: preDiagnosis.altura,
        imc: preDiagnosis.imc,
        pASistolica: preDiagnosis.pASistolica,
        pADiastolica: preDiagnosis.pADiastolica,
        freqCardiaca: preDiagnosis.freqCardiaca,
        freqRepouso: preDiagnosis.freqRepouso,
        temperatura: preDiagnosis.temperatura,
        glicemia: preDiagnosis.glicemia,
        obs: preDiagnosis.observacao,
        dtUltimaMestruacao: preDiagnosis.dtUltimaMestruacao,
        dtProvavelParto: preDiagnosis.dtProvavelParto,
        dtAppointmentEvent: preDiagnosis.appointmentEventDate);
  }

  @override
  List<Object> get props => [];
}

class GetPreDiagnosis extends MedRecordEvent {
  @override
  List<Object> get props => [];
}
