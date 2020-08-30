import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/exams/blocs/exam_bloc.dart';
import 'package:tcc_projeto_app/exams/exam_details_screen.dart';
import 'package:tcc_projeto_app/exams/models/card_exam_info.dart';

class ExamCard extends StatelessWidget {
  final cardExamInfo;
  final examDetails;
  final filePath;
  final examBloc;

  ExamCard(
      {@required this.cardExamInfo,
      @required this.examDetails,
      @required this.filePath,
      @required this.examBloc});

  CardExamInfo get getCardExamInfo => this.cardExamInfo;
  String get getFilePath => this.filePath;
  ExamBloc get getExamBloc => this.examBloc;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        elevation: 4.0,
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Container(
          height: 124,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                getCardExamInfo.examType,
                style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey),
              ),
              Text(
                getCardExamInfo.examDate,
                style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey),
              ),
              _buildDecriptFileButton(context)
            ],
          ),
        ));
  }

  Widget _buildDecriptFileButton(BuildContext context) {
    return SizedBox(
      height: 30.0,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        color: Theme.of(context).primaryColor,
        child: Text(
          "Exibir Exame",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        onPressed: () async {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ExamDetailsScreen(
                    examDetails: this.examDetails,
                    examBloc: this.examBloc,
                    filePath: this.filePath,
                  )));
        },
      ),
    );
  }
}
