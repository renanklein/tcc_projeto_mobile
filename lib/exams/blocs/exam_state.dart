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

class UpdateExamModelProcessing extends ExamState {}

class UpdateExamModelSuccess extends ExamState {}

class UpdateExamModelFail extends ExamState {
  final errorMessage;

  UpdateExamModelFail({@required this.errorMessage});
}

class DeleteExamModelProcessing extends ExamState {}

class DeleteExamModelSuccess extends ExamState {}

class DeleteExamModelFail extends ExamState {}

class ExamSolicitationProcessing extends ExamState{}

class ExamSolicitationSuccess extends ExamState{}

class ExamSolicitationFail extends ExamState{}
