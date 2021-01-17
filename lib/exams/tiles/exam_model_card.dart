import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/exams/screens/exam_model_form.dart';

class ExamModelCard extends StatelessWidget {
  final modelTitle;
  final modelFields;
  final bool isEdit = false;

  ExamModelCard({@required this.modelTitle, @required this.modelFields});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
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
                  this.modelTitle,
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey),
                ),
                _buildShowModelButton(context)
              ],
            ),
          )),
    );
  }

  Widget _buildShowModelButton(BuildContext context) {
    return SizedBox(
        height: 30.0,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
          color: Theme.of(context).primaryColor,
          child: Text(
            "Exibir Modelo",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ExamModelForm(
                      isEdit: true,
                      examModelType: this.modelTitle,
                      examModelFields: this.modelFields,
                    )));
          },
        ));
  }
}
