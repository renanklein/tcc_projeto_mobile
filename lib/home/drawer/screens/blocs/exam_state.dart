part of 'exam_bloc.dart';

abstract class ExamState extends Equatable {
  @override
  List<Object> get props => [];
}

class ExamInitial extends ExamState {}

class ExamProcessing extends ExamState {}

class ExamProcessingSuccess extends ExamState {
  File encriptedFile;
  ExamProcessingSuccess({@required this.encriptedFile});
}

class ExamProcessingFail extends ExamState {}
