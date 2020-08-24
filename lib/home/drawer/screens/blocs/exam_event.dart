part of 'exam_bloc.dart';

abstract class ExamEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SaveExam extends ExamEvent {
  File exam;

  SaveExam({@required this.exam});
}
