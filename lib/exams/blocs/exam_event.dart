part of 'exam_bloc.dart';

abstract class ExamEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateExamModel extends ExamEvent {
  final listOfFields;

  CreateExamModel({@required this.listOfFields});
}

class LoadExamModels extends ExamEvent {}
