part of 'med_record_bloc.dart';

class DiagnosisCreateOrUpdateButtonPressed extends MedRecordEvent {
  final problemId;
  final problemDescription;
  final diagnosisCid;
  final diagnosisDescription;
  final prescriptionMedicine;
  final prescriptionDosage;
  final prescriptionDosageForm;
  final prescriptionUsageOrientation;
  final prescriptionUsageDuration;
  final dynamicFields;
  final String diagnosisDate;
  final bool isUpdate;
  final int id;

  DiagnosisCreateOrUpdateButtonPressed(
      {@required this.problemId,
      @required this.problemDescription,
      @required this.diagnosisCid,
      @required this.diagnosisDescription,
      @required this.prescriptionMedicine,
      @required this.prescriptionDosage,
      @required this.prescriptionDosageForm,
      @required this.prescriptionUsageOrientation,
      @required this.prescriptionUsageDuration,
      @required this.diagnosisDate,
      @required this.isUpdate,
      this.dynamicFields,
      this.id});

  static DiagnosisCreateOrUpdateButtonPressed fromModel(
      bool isUpdate, CompleteDiagnosisModel diagnosisModel) {
    var formater = DateFormat('dd/MM/yyyy');
    var dayAsString = formater.format(diagnosisModel.diagnosisDate);
    return DiagnosisCreateOrUpdateButtonPressed(
        diagnosisDate: dayAsString,
        isUpdate: isUpdate,
        id: diagnosisModel.id,
        problemId: diagnosisModel.problem.problemId,
        problemDescription: diagnosisModel.problem.problemDescription,
        diagnosisCid: diagnosisModel.diagnosis.diagnosisCid,
        diagnosisDescription: diagnosisModel.diagnosis.diagnosisDescription,
        prescriptionDosage: diagnosisModel.prescription.prescriptionDosage,
        prescriptionDosageForm:
            diagnosisModel.prescription.prescriptionDosageForm,
        prescriptionUsageOrientation:
            diagnosisModel.prescription.prescriptionUsageOrientation,
        prescriptionUsageDuration:
            diagnosisModel.prescription.prescriptionUsageDuration,
        dynamicFields: diagnosisModel.dynamicFields,
        prescriptionMedicine: diagnosisModel.prescription.prescriptionMedicine);
  }

  @override
  List<Object> get props => [];
}

class DiagnosisLoad extends MedRecordEvent {
  String _pacientHash;

  DiagnosisLoad({
    @required String pacientCpf,
    @required String pacientSalt,
  }) {
    this._pacientHash = SltPattern.retrivepacientHash(pacientCpf, pacientSalt);
  }

  String get getPacientHash => this._pacientHash;

  @override
  List<Object> get props => [];
}
