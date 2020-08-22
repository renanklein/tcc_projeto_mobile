import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_cripto/cripto_img.dart';
import 'package:encrypt/encrypt.dart' as encryptLib;
import 'package:path_provider/path_provider.dart';

part 'exam_event.dart';
part 'exam_state.dart';

class ExamBloc extends Bloc<ExamEvent, ExamState> {
  final _encripKey = encryptLib.Key.fromSecureRandom(16);

  @override
  Stream<ExamState> mapEventToState(
    ExamEvent event,
  ) async* {
    // TODO: implement mapEventToState
    if (event is SaveExam) {
      try {
        yield ExamProcessing();

        var examBytes = event.exam.readAsBytesSync();
        var encriptedExam = CriptoImage.encrypt(examBytes, this._encripKey);

        String dir = (await getTemporaryDirectory()).path;
        var tempEncriptedFile = File("$dir/temp.file");
        await tempEncriptedFile.writeAsBytes(encriptedExam.bytes);

        yield ExamProcessingSuccess(encriptedFile: tempEncriptedFile);
      } catch (error) {
        yield ExamProcessingFail();
      }
    }
  }

  @override
  // TODO: implement initialState
  ExamState get initialState => throw UnimplementedError();
}
