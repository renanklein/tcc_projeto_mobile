import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/exams/screens/exam_model_form.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

import 'exam_model_exclude.dart';

class ExamModelCard extends StatelessWidget {
  final modelTitle;
  final modelFields;
  final refreshModels;
  final bool isEdit = false;

  ExamModelCard(
      {@required this.modelTitle,
      @required this.modelFields,
      @required this.refreshModels});

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
                  "Tipo de modelo : ${this.modelTitle}",
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey),
                ),
                _buildShowModelButton(context),
                LayoutUtils.buildVerticalSpacing(5.0),
                _buildExcludeModelButton()
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
                      refreshExamModels: this.refreshModels,
                    )));
          },
        ));
  }

  Widget _buildExcludeModelButton() {
    return SizedBox(
      height: 30.0,
      width: 120.0,
      child: Builder(
        builder: (context) => RaisedButton(
          onPressed: () {
            Scaffold.of(context).showBottomSheet((context) {
              return ExamModelExclude(
                examModelToBeExcluded: {
                  "Tipo de Exame": this.modelTitle,
                  "fields": this.modelFields
                },
                refreshModels: this.refreshModels,
              );
            }, backgroundColor: Colors.transparent);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
          color: Colors.red[600],
          child: Text(
            "Excluir",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
