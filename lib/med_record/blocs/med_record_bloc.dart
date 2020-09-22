import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tcc_projeto_app/exams/models/card_exam_info.dart';
import 'package:tcc_projeto_app/exams/models/exam_details.dart';
import 'package:tcc_projeto_app/exams/repositories/exam_repository.dart';
import 'package:tcc_projeto_app/med_record/models/med_record_model.dart';
import 'package:tcc_projeto_app/med_record/repositories/med_record_repository.dart';

part 'med_record_event.dart';
part 'med_record_state.dart';
part 'exam_state.dart';
part 'exam_event.dart';

class MedRecordBloc extends Bloc<MedRecordEvent, MedRecordState> {
  MedRecordRepository medRecordRepository;
  ExamRepository examRepository;

  MedRecordBloc(
      {@required this.medRecordRepository, @required this.examRepository})
      : super(null);

  MedRecordState get initialState => MedRecordInicialState();

  @override
  Stream<MedRecordState> mapEventToState(
    MedRecordEvent event,
  ) async* {
    if (event is MedRecordCreateButtonPressed) {
      try {
        yield CreateMedRecordEventProcessing();

        await medRecordRepository.updateMedRecord(
            pacientHash: event.pacientHash,
            medRecordModel: MedRecordModel(pacientHash: '22'));

        yield CreateMedRecordEventSuccess();
      } catch (error) {
        yield CreateMedRecordEventFail();
      }
    } else if (event is MedRecordLoad) {
      try {
        yield MedRecordLoading();

        medRecordRepository.pacientHash = event.hash;

        var medRecord = await this.medRecordRepository.getMedRecordByCpf();

        yield MedRecordLoadEventSuccess(medRecord);
      } catch (error) {
        yield MedRecordLoadEventFail();
      }
    } else if (event is MedRecordEditButtonPressed) {
      try {} catch (error) {}
    } else if (event is MedRecordDeleteButtonPressed) {
      try {} catch (error) {}
    }
    if (event is SaveExam) {
      try {
        yield ExamProcessing();

        var examBytes = await event.getExamFile.readAsBytes();

        var encoded = base64.encode(examBytes);

        String dir = (await getApplicationDocumentsDirectory()).path;
        var randomFileName = Random.secure().nextInt(10000);
        var filePath = "$dir/$randomFileName.txt";
        var encriptedFile = File("$dir/$randomFileName.txt");
        await encriptedFile.writeAsString(encoded);

        await this
            .examRepository
            .saveExam(event.getCardExamInfo, event.getExamDetails, filePath);

        yield ExamProcessingSuccess(encriptedFile: encriptedFile);
      } catch (error) {
        yield ExamProcessingFail();
      }
    } else if (event is GetExams) {
      try {
        yield ExamProcessing();

        var examInfoList = await this.examRepository.getExam();

        List examCards = [];
        List examDetails = [];
        List examFilePaths = [];

        for (int i = 0; i < examInfoList.length; i += 3) {
          examCards.add(examInfoList[i]);
          examDetails.add(examInfoList[i + 1]);
          examFilePaths.add(examInfoList[i + 2]);
        }
        yield GetExamsSuccess(
            cardExamInfos: examCards,
            examDetailsList: examDetails,
            filePaths: examFilePaths);
      } catch (error) {
        yield ExamProcessingFail();
      }
    } else if (event is DecriptExam) {
      try {
        yield ExamProcessing();

        var filePath = event.filePath;

        var file = File(filePath);
        var bytes = await file.readAsString();
        var decriptedBytes = base64.decode(bytes);

        yield DecriptExamSuccess(decriptedBytes: decriptedBytes);
      } catch (error) {
        yield ExamProcessingFail();
      }
    }
  }
}
