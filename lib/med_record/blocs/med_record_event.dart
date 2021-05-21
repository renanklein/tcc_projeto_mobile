part of 'med_record_bloc.dart';

abstract class MedRecordEvent extends Equatable {}

class MedRecordCreateButtonPressed extends MedRecordEvent {
  final _pacientHash;

  MedRecordCreateButtonPressed(
    this._pacientHash,
  );

  @override
  List<Object> get props => [];
}

class MedRecordPacientDetailButtonPressed extends MedRecordEvent {
  final _pacientCpf;

  MedRecordPacientDetailButtonPressed(
    this._pacientCpf,
  );

  @override
  List<Object> get props => [];
}

class MedRecordLoad extends MedRecordEvent {
  String _pacientHash;

  MedRecordLoad({
    @required String pacientCpf,
    @required String pacientSalt,
  }) {
    this._pacientHash = SltPattern.retrivepacientHash(pacientCpf, pacientSalt);
  }

  String get getPacientHash => this._pacientHash;

  @override
  List<Object> get props => [];
}

class OverviewCreateOrUpdateButtonPressed extends MedRecordEvent {
  String _pacientHash;
  String _overview;

  OverviewCreateOrUpdateButtonPressed({
    @required String pacientCpf,
    @required String pacientSalt,
    @required String resumo,
  }) {
    this._pacientHash = SltPattern.retrivepacientHash(pacientCpf, pacientSalt);
    this._overview = resumo;
  }

  String get getPacientHash => this._pacientHash;
  String get overview => this._overview;

  @override
  List<Object> get props => [];
}

class MedRecordEditButtonPressed extends MedRecordEvent {
  MedRecordEditButtonPressed();

  @override
  List<Object> get props => [];
}

class MedRecordDeleteButtonPressed extends MedRecordEvent {
  MedRecordDeleteButtonPressed();

  @override
  List<Object> get props => [];
}

class SaveExam extends MedRecordEvent {
  final cardExamInfo;
  final examDetails;
  final examFile;
  final medRecordArguments;

  SaveExam(
      {@required this.cardExamInfo,
      @required this.examDetails,
      @required this.examFile,
      @required this.medRecordArguments});

  CardExamInfo get getCardExamInfo => this.cardExamInfo;
  ExamDetails get getExamDetails => this.examDetails;
  File get getExamFile => this.examFile;
  MedRecordArguments get getMedRecordArguments => this.medRecordArguments;

  @override
  List<Object> get props => [];
}

class GetExams extends MedRecordEvent {
  final pacientHash;
  GetExams({@required this.pacientHash});
  @override
  List<Object> get props => [];
}

class DecryptExam extends MedRecordEvent {
  final fileDownloadURL;
  final iv;

  DecryptExam({@required this.fileDownloadURL, @required this.iv});

  @override
  List<Object> get props => [];
}

class DinamicExamField extends MedRecordEvent {
  final fieldName;
  final fieldValue;

  DinamicExamField({@required this.fieldName, @required this.fieldValue});

  @override
  List<Object> get props => [];
}

class LoadExamModels extends MedRecordEvent {
  @override
  List<Object> get props => [];
}
