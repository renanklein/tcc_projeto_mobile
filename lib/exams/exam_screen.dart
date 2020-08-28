import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcc_projeto_app/exams/blocs/exam_bloc.dart';
import 'package:tcc_projeto_app/exams/tiles/exam_card.dart';
import 'package:tcc_projeto_app/exams/exam_form_screen.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

class ExamScreen extends StatefulWidget {
  @override
  _ExamScreenState createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  bool isDecripted = false;
  ExamBloc examBloc;
  Map exams;
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
    this.examBloc.add(GetExams());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Exames",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ExamFormScreen()));
            },
          )
        ],
      ),
      body: BlocListener<ExamBloc, ExamState>(
        cubit: examBloc,
        listener: (context, state) {
          if (state is ExamProcessingFail) {
            onFail("Ocorreu um erro");
          } else if (state is GetExamsSuccess) {
            this.exams = state.exams;
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
      ),
    );
  }

  void onFail(String message) {
    this._scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            message,
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
        ));
  }

  List<Widget> _buildScreenBody() {
    if (this.exams != null && this.exams.isNotEmpty) {
      return <Widget>[
        ExamCard(
          examBloc: examBloc,
          title: exams["pacient"],
          fileName: exams["fileName"],
          textBody: exams["filePath"],
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
    return <Widget>[Container()];
  }

  Widget _showDecriptedImage() {
    String dir = this.exams["filePath"];
    final file = File("$dir/test.jpg");
    file.writeAsBytesSync(this.decriptedBytes);
    return Image.file(file);
  }
}
