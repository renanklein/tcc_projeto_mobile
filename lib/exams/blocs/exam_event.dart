part of 'exam_bloc.dart';

abstract class ExamEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateExamModel extends ExamEvent {
  final listOfFields;
  final examTypeMap;
  final examDateMap;

  CreateExamModel(
      {@required this.listOfFields,
      @required this.examTypeMap,
      @required this.examDateMap});
}
