import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcc_projeto_app/exams/tiles/exam_card.dart';
import 'package:tcc_projeto_app/med_record/blocs/med_record_bloc.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

class ExamScreen extends StatefulWidget {
  final pacientHash;
  ExamScreen({@required this.pacientHash});
  @override
  _ExamScreenState createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  bool isDecripted = false;
  MedRecordBloc medRecordBloc;
  List cardExamInfos;
  List examDetailsList;
  List fileDownloadURLs;
  List ivs;
  Uint8List decriptedBytes = Uint8List(0);

  String get pacientHash => this.widget.pacientHash;

  @override
  void initState() {
    this.medRecordBloc = BlocProvider.of<MedRecordBloc>(context);
    _loadExamCards();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MedRecordBloc, MedRecordState>(
      cubit: medRecordBloc,
      listener: (context, state) {
        if (state is ExamProcessingFail) {
        } else if (state is GetExamsSuccess) {
          this.cardExamInfos = state.cardExamInfos;
          this.examDetailsList = state.examDetailsList;
          this.fileDownloadURLs = state.fileDownloadURLs;
          this.ivs = state.ivs;
        } else if (state is DecryptExamSuccess) {
          this.isDecripted = true;
          this.decriptedBytes = state.decriptedBytes;
        }
      },
      child: BlocBuilder<MedRecordBloc, MedRecordState>(
        cubit: medRecordBloc,
        builder: (context, state) {
          if (state is ExamProcessing) {
            return LayoutUtils.buildCircularProgressIndicator(context);
          }
          return Padding(
            padding: const EdgeInsets.all(14.0),
            child: ListView(
              children: _buildScreenBody(),
            ),
          );
        },
      ),
    );
  }

  void onFail(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        message,
        style: TextStyle(
            fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.white),
      ),
    ));
  }

  List<Widget> _buildScreenBody() {
    if (_existsExamInfo()) {
      List<Widget> examCards = [];
      for (int i = 0; i < this.cardExamInfos.length; i++) {
        examCards.add(
          ExamCard(
            medRecordBloc: this.medRecordBloc,
            fileDownloadURL: this.fileDownloadURLs[i],
            cardExamInfo: this.cardExamInfos[i],
            examDetails: this.examDetailsList[i],
            iv: this.ivs[i],
          ),
        );
        examCards.add(LayoutUtils.buildVerticalSpacing(15.0));
      }
      return examCards;
    }
    return <Widget>[
      Container(
        child: Center(
          child: Text(
            "Nenhum exame foi encontrado",
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w300,
                color: Theme.of(context).primaryColor),
          ),
        ),
      )
    ];
  }

  bool _existsExamInfo() {
    return (this.cardExamInfos != null && this.cardExamInfos.isNotEmpty) &&
        (this.examDetailsList != null && this.examDetailsList.isNotEmpty) &&
        (this.fileDownloadURLs != null && this.fileDownloadURLs.isNotEmpty);
  }

  void _loadExamCards() {
    this.medRecordBloc.add(GetExams(pacientHash: this.pacientHash));
  }
}
