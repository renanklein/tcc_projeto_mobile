part of 'exam_bloc.dart';

abstract class ExamState extends Equatable {
  @override
  List<Object> get props => [];
}

class ExamInitial extends ExamState {}

class CreateExamModelProcessing extends ExamState {}

class CreateExamModelFail extends ExamState {
  final String errorMessage;

  CreateExamModelFail({@required this.errorMessage});
}

class CreateExamModelSuccess extends ExamState {}
