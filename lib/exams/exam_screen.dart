import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcc_projeto_app/exams/blocs/exam_bloc.dart';
import 'package:tcc_projeto_app/exams/models/card_exam_info.dart';
import 'package:tcc_projeto_app/exams/models/exam_details.dart';
import 'package:tcc_projeto_app/exams/tiles/exam_card.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

class ExamScreen extends StatefulWidget {
  @override
  _ExamScreenState createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  bool isDecripted = false;
  ExamBloc examBloc;
  CardExamInfo cardExamInfo;
  ExamDetails examDetails;
  String filePath;
  Uint8List decriptedBytes = Uint8List(0);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    this.examBloc = BlocProvider.of<ExamBloc>(context);
    this.examBloc.add(GetExams());
    super.initState();
  }

  @override
  void dispose() {
    this.examBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExamBloc, ExamState>(
      cubit: examBloc,
      listener: (context, state) {
        if (state is ExamProcessingFail) {
          onFail("Ocorreu um erro");
        } else if (state is GetExamsSuccess) {
          this.cardExamInfo = state.cardExamInfo;
          this.examDetails = state.examDetails;
          this.filePath = state.filePath;
        } else if (state is DecriptExamSuccess) {
          this.isDecripted = true;
          this.decriptedBytes = state.decriptedBytes;
        }
      },
      child: BlocBuilder<ExamBloc, ExamState>(
        cubit: examBloc,
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
      return <Widget>[
        ExamCard(
          examBloc: examBloc,
          filePath: this.filePath,
          cardExamInfo: cardExamInfo,
        ),
        LayoutUtils.buildHorizontalSpacing(10.0),
        this.isDecripted
            ? Container(
                child: _showDecriptedImage(),
                height: 150,
                width: 150,
              )
            : Container()
      ];
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

  Widget _showDecriptedImage() {
    String dir = this.filePath;
    final file = File(dir);
    file.writeAsBytesSync(this.decriptedBytes);
    return Image.file(file);
  }

  bool _existsExamInfo() {
    return this.cardExamInfo != null && this.examDetails != null;
  }
}
