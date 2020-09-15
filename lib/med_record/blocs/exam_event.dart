part of 'med_record_bloc.dart';

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
  // TODO: implement props
  List<Object> get props => [];
}

// TODO: Alterar evento se necessário
class GetExams extends MedRecordEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class DecriptExam extends MedRecordEvent {
  final filePath;

  DecriptExam({@required this.filePath});

  @override
  // TODO: implement props
  List<Object> get props => [];
}
