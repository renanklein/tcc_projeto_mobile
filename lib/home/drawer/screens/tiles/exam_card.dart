import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/home/drawer/screens/blocs/exam_bloc.dart';

class ExamCard extends StatelessWidget {
  final title;
  final textBody;
  final fileName;
  final examBloc;

  ExamCard(
      {@required this.title,
      @required this.textBody,
      @required this.fileName,
      @required this.examBloc});

  String get getTitle => this.title;
  String get getTextBody => this.textBody;
  String get getFilePath => this.fileName;
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
                title,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Text(
                textBody,
                style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey),
              ),
              Text(
                "Nome de arquivo criptografado : $fileName",
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
        onPressed: () {
          this.examBloc.add(DecriptExam(fileName: fileName));
        },
      ),
    );
  }
}
