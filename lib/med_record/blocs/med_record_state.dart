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
  Map<String, List<dynamic>> _medRecordsLoaded;

  MedRecordLoadEventSuccess(Map<String, List<dynamic>> medRecords) {
    this._medRecordsLoaded = medRecords;
  }

  Map<String, List<dynamic>> get medRecordsLoaded => this._medRecordsLoaded;

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

class MedRecordEventProcessing extends MedRecordState {
  @override
  List<Object> get props => [];
}

class ExamInitial extends MedRecordState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ExamProcessing extends MedRecordState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GetExamsSuccess extends MedRecordState {
  final cardExamInfo;
  final examDetails;
  final filePath;

  GetExamsSuccess(
      {@required this.cardExamInfo,
      @required this.examDetails,
      @required this.filePath});

  CardExamInfo get getCardExamInfo => this.cardExamInfo;
  ExamDetails get getExamDetails => this.examDetails;
  String get getFilePath => this.filePath;

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ExamProcessingSuccess extends MedRecordState {
  File encriptedFile;
  ExamProcessingSuccess({@required this.encriptedFile});

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class DecriptExamSuccess extends MedRecordState {
  final decriptedBytes;

  DecriptExamSuccess({@required this.decriptedBytes});

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ExamProcessingFail extends MedRecordState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}
