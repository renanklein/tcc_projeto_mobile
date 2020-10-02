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
import 'package:http/http.dart' as http;

part 'med_record_event.dart';
part 'med_record_state.dart';
part 'diagnosis_state.dart';
part 'diagnosis_event.dart';

class MedRecordBloc extends Bloc<MedRecordEvent, MedRecordState> {
  MedRecordRepository medRecordRepository;
  ExamRepository examRepository;

  MedRecordBloc({
    @required this.medRecordRepository,
    this.examRepository,
  }) : super(null);

  MedRecordState get initialState => MedRecordInicialState();

  @override
  Stream<MedRecordState> mapEventToState(
    MedRecordEvent event,
  ) async* {
    if (event is MedRecordCreateButtonPressed) {
      try {
        yield CreateMedRecordEventProcessing();

        //TODO: Inserção itens Prontuario

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

        MedRecordModel medRecord = await this
            .medRecordRepository
            .getMedRecordByCpf(event.getPacientHash);

        yield MedRecordLoadEventSuccess(medRecord: medRecord);
      } catch (error) {
        yield MedRecordLoadEventFail();
      }
    } else if (event is MedRecordEditButtonPressed) {
      try {} catch (error) {}
    } else if (event is MedRecordDeleteButtonPressed) {
      try {} catch (error) {}
    }

    if (event is DiagnosisCreateButtonPressed) {
      try {
        yield DiagnosisCreateEventProcessing();

        yield DiagnosisCreateEventSuccess();
      } catch (error) {
        yield DiagnosisCreateEventFail();
      }
    }

    if (event is SaveExam) {
      try {
        yield ExamProcessing();

        var examBytes = await event.getExamFile.readAsBytes();

        var encoded = base64.encode(examBytes);
        var tempDir = await getTemporaryDirectory();
        var tempPath = tempDir.path;
        var randomFileName = Random.secure().nextInt(10000);
        var fileName = randomFileName.toString();
        var encriptedFile = File("$tempPath/$fileName");
        await encriptedFile.writeAsString(encoded);

        await this.examRepository.saveExam(event.getCardExamInfo,
            event.getExamDetails, encriptedFile, randomFileName.toString());

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
        List examFileDownloadURLs = [];

        for (int i = 0; i < examInfoList.length; i += 3) {
          examCards.add(examInfoList[i]);
          examDetails.add(examInfoList[i + 1]);
          examFileDownloadURLs.add(examInfoList[i + 2]);
        }
        yield GetExamsSuccess(
            cardExamInfos: examCards,
            examDetailsList: examDetails,
            fileDownloadURLs: examFileDownloadURLs);
      } catch (error) {
        yield ExamProcessingFail();
      }
    } else if (event is DecriptExam) {
      try {
        yield ExamProcessing();

        var fileDownloadURL = event.fileDownloadURL;

        var response = await http.get(fileDownloadURL);
        var bytes = response.body;
        var decriptedBytes = base64.decode(bytes);

        yield DecriptExamSuccess(decriptedBytes: decriptedBytes);
      } catch (error) {
        yield ExamProcessingFail();
      }
    }
  }
}
