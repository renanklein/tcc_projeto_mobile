part of 'med_record_bloc.dart';

class DiagnosisCreateButtonPressed extends MedRecordEvent {
  final problemId;
  final problemDescription;
  final diagnosisCid;
  final diagnosisDescription;
  final prescriptionMedicine;
  final prescriptionDosage;
  final prescriptionDosageForm;
  final prescriptionUsageOrientation;
  final prescriptionUsageDuration;

  DiagnosisCreateButtonPressed({
    @required this.problemId,
    @required this.problemDescription,
    @required this.diagnosisCid,
    @required this.diagnosisDescription,
    @required this.prescriptionMedicine,
    @required this.prescriptionDosage,
    @required this.prescriptionDosageForm,
    @required this.prescriptionUsageOrientation,
    @required this.prescriptionUsageDuration,
  });

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GetDiagnosis extends MedRecordEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}
