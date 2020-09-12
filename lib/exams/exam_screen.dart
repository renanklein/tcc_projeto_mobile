import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcc_projeto_app/exams/models/card_exam_info.dart';
import 'package:tcc_projeto_app/exams/models/exam_details.dart';
import 'package:tcc_projeto_app/exams/tiles/exam_card.dart';
import 'package:tcc_projeto_app/med_record/blocs/med_record_bloc.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

class ExamScreen extends StatefulWidget {
  @override
  _ExamScreenState createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  bool isDecripted = false;
  MedRecordBloc medRecordBloc;
  List cardExamInfos;
  List examDetailsList;
  List filePaths;
  Uint8List decriptedBytes = Uint8List(0);
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
          this.filePaths = state.filePaths;
        } else if (state is DecriptExamSuccess) {
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
    Scaffold.of(context).showSnackBar(SnackBar(
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
            filePath: this.filePaths[i],
            cardExamInfo: this.cardExamInfos[i],
            examDetails: this.examDetailsList[i],
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
    return this.cardExamInfos != null &&
        this.examDetailsList != null &&
        this.filePaths != null;
  }

  void _loadExamCards() {
    this.medRecordBloc.add(GetExams());
  }
}
