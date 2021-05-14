part of 'med_record_bloc.dart';

class DiagnosisCreateOrUpdateButtonPressed extends MedRecordEvent {
  final problemId;
  final problemDescription;
  final diagnosisCid;
  final diagnosisDescription;
  final prescription;
  /*  final prescriptionDosage;
  final prescriptionDosageForm;
  final prescriptionUsageOrientation;
  final prescriptionUsageDuration; */
  final dynamicFields;
  final String diagnosisDate;
  final bool isUpdate;
  final int id;

  DiagnosisCreateOrUpdateButtonPressed({
    @required this.problemId,
    @required this.problemDescription,
    @required this.diagnosisCid,
    @required this.diagnosisDescription,
    @required this.prescription,
    @required this.diagnosisDate,
    @required this.isUpdate,
    this.dynamicFields,
    this.id,
  });

  static DiagnosisCreateOrUpdateButtonPressed fromModel(
      bool isUpdate, CompleteDiagnosisModel diagnosisModel) {
    var formater = DateFormat('dd/MM/yyyy');
    var dayAsString = formater.format(diagnosisModel.diagnosisDate);

    var _diagnosisCid;
    var _diagnosisDescription;

    return DiagnosisCreateOrUpdateButtonPressed(
        diagnosisDate: dayAsString,
        isUpdate: isUpdate,
        id: diagnosisModel.id,
        problemId: diagnosisModel.problem.problemId,
        problemDescription: diagnosisModel.problem.problemDescription,
        diagnosisCid: _diagnosisCid,
        diagnosisDescription: _diagnosisDescription,
        dynamicFields: diagnosisModel.dynamicFields,
        prescription: diagnosisModel.prescription);
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
