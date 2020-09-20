part of 'med_record_bloc.dart';

abstract class MedRecordEvent extends Equatable {}

class MedRecordCreateButtonPressed extends MedRecordEvent {
  //final userId;

  MedRecordCreateButtonPressed(//@required this.userId,

      );

  @override
  List<Object> get props => [];
}

class MedRecordLoad extends MedRecordEvent {
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

  SaveExam(
      {@required this.cardExamInfo,
      @required this.examDetails,
      @required this.examFile});

  CardExamInfo get getCardExamInfo => this.cardExamInfo;
  ExamDetails get getExamDetails => this.examDetails;
  File get getExamFile => this.examFile;

  @override
  List<Object> get props => [];
}

class GetExams extends MedRecordEvent {
  @override
  List<Object> get props => [];
}

class DecriptExam extends MedRecordEvent {
  final filePath;

  DecriptExam({@required this.filePath});

  @override
  List<Object> get props => [];
}
