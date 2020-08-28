part of 'exam_bloc.dart';

abstract class ExamEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SaveExam extends ExamEvent {
  final exam;
  final pacientName;

  SaveExam({@required this.exam, @required this.pacientName});

  File get getExam => this.exam;
  String get getPacientName => this.pacientName;
}

// TODO: Alterar evento se necessário
class GetExams extends ExamEvent {}

class DecriptExam extends ExamEvent {
  final fileName;

  DecriptExam({@required this.fileName});
}
