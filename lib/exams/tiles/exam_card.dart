import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/exams/models/card_exam_info.dart';
import 'package:tcc_projeto_app/exams/screens/exam_details_screen.dart';
import 'package:tcc_projeto_app/med_record/blocs/med_record_bloc.dart';

class ExamCard extends StatelessWidget {
  final cardExamInfo;
  final examDetails;
  final filePath;
  final medRecordBloc;

  ExamCard(
      {@required this.cardExamInfo,
      @required this.examDetails,
      @required this.filePath,
      @required this.medRecordBloc});

  CardExamInfo get getCardExamInfo => this.cardExamInfo;
  String get getFilePath => this.filePath;
  MedRecordBloc get getMedRecordBloc => this.medRecordBloc;

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
          this.medRecordBloc.add(DecriptExam(filePath: this.filePath));
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ExamDetailsScreen(
                    examDetails: this.examDetails,
                    filePath: this.filePath,
                  )));
        },
      ),
    );
  }
}
