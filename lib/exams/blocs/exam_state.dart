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

class LoadExamModelProcessing extends ExamState {}

class LoadExamModelFail extends ExamState {
  final String errorMessage;

  LoadExamModelFail({@required this.errorMessage});
}

class LoadExamModelSuccess extends ExamState {
  final Map models;

  LoadExamModelSuccess({@required this.models});
}
