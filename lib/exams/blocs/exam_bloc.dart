import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:encrypt/encrypt.dart' as encryptLib;
import 'package:path_provider/path_provider.dart';
import 'package:tcc_projeto_app/exams/models/card_exam_info.dart';
import 'package:tcc_projeto_app/exams/models/exam_details.dart';
import 'package:tcc_projeto_app/exams/repositories/exam_repository.dart';

part 'exam_event.dart';
part 'exam_state.dart';

class ExamBloc extends Bloc<ExamEvent, ExamState> {
  final _encripKey = encryptLib.Key.fromSecureRandom(16);
  ExamRepository examRepository;

  ExamBloc({@required this.examRepository}) : super(null);

  @override
  Stream<ExamState> mapEventToState(
    ExamEvent event,
  ) async* {
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

        yield GetExamsSuccess(
            cardExamInfo: examInfoList.first,
            examDetails: examInfoList[1],
            filePath: examInfoList.last);
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

  @override
  // TODO: implement initialState
  ExamState get initialState => ExamInitial();
}
