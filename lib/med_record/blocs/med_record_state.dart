part of 'med_record_bloc.dart';

abstract class MedRecordState extends Equatable {}

class MedRecordInicialState extends MedRecordState {
  @override
  List<Object> get props => [];
}

class CreateMedRecordEventProcessing extends MedRecordState {
  @override
  List<Object> get props => [];
}

class CreateMedRecordEventSuccess extends MedRecordState {
  @override
  List<Object> get props => [];
}

class CreateMedRecordEventFail extends MedRecordState {
  @override
  List<Object> get props => [];
}

class EditMedRecordEventSuccess extends MedRecordState {
  @override
  List<Object> get props => [];
}

class EditMedRecordEventFail extends MedRecordState {
  @override
  List<Object> get props => [];
}

class DeleteMedRecordEventSuccess extends MedRecordState {
  @override
  List<Object> get props => [];
}

class DeleteMedRecordEventFail extends MedRecordState {
  @override
  List<Object> get props => [];
}

class MedRecordLoadEventSuccess extends MedRecordState {
  MedRecordModel _medRecordLoaded;

  MedRecordLoadEventSuccess({@required MedRecordModel medRecord}) {
    this._medRecordLoaded = medRecord;
  }

  MedRecordModel get medRecordLoaded => this._medRecordLoaded;

  @override
  List<Object> get props => [];
}

class MedRecordLoadEventFail extends MedRecordState {
  @override
  List<Object> get props => [];
}

class MedRecordLoading extends MedRecordState {
  @override
  List<Object> get props => [];
}

class MedRecordPacientDetailLoading extends MedRecordState {
  @override
  List<Object> get props => [];
}

class MedRecordPacientDetailLoadEventSuccess extends MedRecordState {
  PacientModel _pacient;

  MedRecordPacientDetailLoadEventSuccess({@required PacientModel pacient}) {
    this._pacient = pacient;
  }

  PacientModel get pacientModelLoaded => this._pacient;

  @override
  List<Object> get props => [];
}

class MedRecordPacientDetailLoadEventFailure extends MedRecordState {
  @override
  List<Object> get props => [];
}

class MedRecordEventProcessing extends MedRecordState {
  @override
  List<Object> get props => [];
}

class MedRecordEventSuccess extends MedRecordState {
  @override
  List<Object> get props => [];
}

class MedRecordEventFailure extends MedRecordState {
  @override
  List<Object> get props => [];
}

class ExamInitial extends MedRecordState {
  @override
  List<Object> get props => [];
}

class ExamProcessing extends MedRecordState {
  @override
  List<Object> get props => [];
}

class GetExamsSuccess extends MedRecordState {
  final cardExamInfos;
  final examDetailsList;
  final fileDownloadURLs;
  final ivs;

  GetExamsSuccess(
      {@required this.cardExamInfos,
      @required this.examDetailsList,
      @required this.fileDownloadURLs,
      @required this.ivs});

  List get getCardExamInfo => this.cardExamInfos;
  List get getExamDetails => this.examDetailsList;
  List get getFileDownloadURLs => this.fileDownloadURLs;
  List get getIvs => this.ivs;

  @override
  List<Object> get props => [];
}

class ExamProcessingSuccess extends MedRecordState {
  File encriptedFile;
  ExamProcessingSuccess({@required this.encriptedFile});

  @override
  List<Object> get props => [];
}

class DecryptExamSuccess extends MedRecordState {
  final decriptedBytes;

  DecryptExamSuccess({@required this.decriptedBytes});

  @override
  List<Object> get props => [];
}

class ExamProcessingFail extends MedRecordState {
  @override
  List<Object> get props => [];
}

class DynamicExamFieldProcessing extends MedRecordState {
  @override
  List<Object> get props => [];
}

class DynamicExamFieldSuccess extends MedRecordState {
  final dynamicFieldWidget;
  DynamicExamFieldSuccess({@required this.dynamicFieldWidget});

  @override
  List<Object> get props => [];
}

class DynamicExamFieldFail extends MedRecordState {
  @override
  List<Object> get props => [];
}

class LoadExamModelProcessing extends MedRecordState {
  @override
  List<Object> get props => [];
}

class LoadExamModelFail extends MedRecordState {
  final String errorMessage;

  LoadExamModelFail({@required this.errorMessage});

  @override
  List<Object> get props => [];
}

class LoadExamModelSuccess extends MedRecordState {
  final Map models;

  LoadExamModelSuccess({@required this.models});

  @override
  List<Object> get props => [];
}
