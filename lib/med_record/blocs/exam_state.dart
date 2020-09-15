part of 'med_record_bloc.dart';

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
  final filePaths;

  GetExamsSuccess(
      {@required this.cardExamInfo,
      @required this.examDetails,
      @required this.filePaths});

  List<CardExamInfo> get getCardExamInfo => this.cardExamInfo;
  List<ExamDetails> get getExamDetails => this.examDetails;
  List<String> get getFilePath => this.filePaths;

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
