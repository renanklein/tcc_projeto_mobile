import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:tcc_projeto_app/exams/models/exam_solicitation_model.dart';
import 'package:tcc_projeto_app/exams/repositories/exam_repository.dart';

part 'exam_event.dart';
part 'exam_state.dart';

class ExamBloc extends Bloc<ExamEvent, ExamState> {
  ExamRepository examRepository;

  ExamBloc({@required this.examRepository}) : super(null){
    on<CreateExamModel>((event, emit) async{
      try {
        emit(CreateExamModelProcessing());

        var modelMap = Map<String, dynamic>();
        modelMap.addAll(event.examTypeMap);
        modelMap.addAll({"fields": event.mapOfFields});

        await this
            .examRepository
            .saveModelExam(modelMap, event.examTypeMap["Tipo de Exame"]);

        emit(CreateExamModelSuccess());
      } catch (error, stack_trace) {
        await FirebaseCrashlytics.instance.recordError(error, stack_trace);
        emit(CreateExamModelFail(errorMessage: error.toString()));
      }
    });

    on<UpdateExamModel>((event, emit) async{
      try {
        emit(UpdateExamModelProcessing());

        await this.examRepository.updateExamModels(
            event.examModelType, event.mapOfFields, event.oldExamModelType);

        emit(UpdateExamModelSuccess());
      } catch (err, stack_trace) {
        await FirebaseCrashlytics.instance.recordError(err, stack_trace);
        emit(UpdateExamModelFail(errorMessage: err.toString()));
      }
    });

    on<DeleteExamModel>((event, emit) async{
       try {
        emit(DeleteExamModelProcessing());

        await this.examRepository.deleteExamModels(event.modelsToBeRemoved);


        emit(DeleteExamModelSuccess());

      } catch (err, stack_trace) {
        await FirebaseCrashlytics.instance.recordError(err, stack_trace);
        emit(DeleteExamModelFail());
      }
    });

    on<CreateExamSolicitation>((event, emit) async{
      try {
        emit(ExamSolicitationProcessing());

        this.examRepository.saveExamSolicitation(event.solicitationExamType,
            event.solicitationDate, event.pacientHash);
        emit(ExamSolicitationSuccess());
      } catch (err, stack_trace) {
        await FirebaseCrashlytics.instance.recordError(err, stack_trace);
        emit(ExamSolicitationFail());
      }
    });

    on<GetExamSolicitations>((event, emit) async{
       try {
        emit(GetExamSolicitationsProcessing());

        var solicitations =
            await this.examRepository.getExamSolictations(event.pacientHash);

        emit(GetExamSolicitationsSuccess(solicitations: solicitations));
      } catch (error, stack_trace) {
        await FirebaseCrashlytics.instance.recordError(error, stack_trace);
        emit(ExamSolicitationFail());
      }
    });

    on<GetExamBySolicitationId>((event, emit) async{
      emit(GetExamBySolicitationIdProcessing());

      var exam = await this
          .examRepository
          .getExamBySolicitationId(event.examSolicitationId, event.pacientHash);

      emit(GetExamBySolicitationIdSuccess(exam: exam));
    });

    on<ExistsExamModel>((event, emit) async{
       try {
        emit(ExistsExamModelProcessing());

        var existsExamModel =
            await this.examRepository.existsExamModel(event.examType);

        emit(ExistsExamModelSuccess(existsExamModel: existsExamModel));
      } catch (error, stack_trace) {
        await FirebaseCrashlytics.instance.recordError(error, stack_trace);
        emit(ExistsExamModelFail());
      }
    });
  }
  ExamState get initialState => ExamInitial();
}
