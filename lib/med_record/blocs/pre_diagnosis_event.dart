part of 'med_record_bloc.dart';

class PreDiagnosisCreateOrUpdateButtonPressed extends MedRecordEvent {
  final int peso;
  final int altura;
  final double imc;
  final int pASistolica;
  final int pADiastolica;
  final int freqCardiaca;
  final int freqRepouso;
  final double temperatura;
  final int glicemia;
  final String obs;
  final dtUltimaMestruacao;
  final dtProvavelParto;
  final dtAppointmentEvent;
  final dtPrediagnosis;
  final bool isUpdate;
  final dynamicFields;

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
      @required this.isUpdate,
      this.obs,
      this.dtUltimaMestruacao,
      this.dtProvavelParto,
      @required this.dtAppointmentEvent,
      @required this.dtPrediagnosis,
      this.dynamicFields});

  static PreDiagnosisCreateOrUpdateButtonPressed fromModel(
      PreDiagnosisModel preDiagnosis, bool isUpdate) {
    return PreDiagnosisCreateOrUpdateButtonPressed(
        isUpdate: isUpdate,
        peso: preDiagnosis.peso,
        altura: preDiagnosis.altura,
        imc: preDiagnosis.imc,
        pASistolica: preDiagnosis.pASistolica,
        pADiastolica: preDiagnosis.pADiastolica,
        freqCardiaca: preDiagnosis.freqCardiaca,
        freqRepouso: preDiagnosis.freqRepouso,
        temperatura: preDiagnosis?.temperatura,
        glicemia: preDiagnosis?.glicemia,
        obs: preDiagnosis.observacao,
        dtUltimaMestruacao: preDiagnosis.dtUltimaMestruacao,
        dtProvavelParto: preDiagnosis.dtProvavelParto,
        dtAppointmentEvent: preDiagnosis.appointmentEventDate,
        dtPrediagnosis: preDiagnosis.getPreDiagnosisDate,
        dynamicFields: preDiagnosis.dynamicFields);
  }

  @override
  List<Object> get props => [];
}

class GetPreDiagnosis extends MedRecordEvent {
  @override
  List<Object> get props => [];
}
