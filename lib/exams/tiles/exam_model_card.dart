import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/exams/screens/exam_model_form.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

class ExamModelCard extends StatefulWidget {
  final modelTitle;
  final modelFields;
  final refreshModels;
  final refreshIncludeModelsToExclude;
  final refreshRemoveModelsToExclude;

  ExamModelCard(
      {@required this.modelTitle,
      @required this.modelFields,
      @required this.refreshModels,
      @required this.refreshIncludeModelsToExclude,
      @required this.refreshRemoveModelsToExclude});

  @override
  _ExamModelCardState createState() => _ExamModelCardState();
}

class _ExamModelCardState extends State<ExamModelCard> {
  final bool isEdit = false;

  Function get refreshIncludeModelsToExclude =>
      this.widget.refreshIncludeModelsToExclude;

  Function get refreshRemoveModelsToExclude =>
      this.widget.refreshRemoveModelsToExclude;

  Color cardBackgroundColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (this.cardBackgroundColor == Colors.white) {
          this.cardBackgroundColor = Colors.grey[300];
          this.refreshIncludeModelsToExclude(
            {
              "Tipo de Exame": this.widget.modelTitle,
              "fields": this.widget.modelFields
            },
          );
        } else {
          this.cardBackgroundColor = Colors.white;
          this.refreshRemoveModelsToExclude(
            {
              "Tipo de Exame": this.widget.modelTitle,
              "fields": this.widget.modelFields
            },
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
            color: cardBackgroundColor,
            elevation: 4.0,
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            child: Container(
              height: 124,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    "Tipo de modelo : ${this.widget.modelTitle}",
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey),
                  ),
                  LayoutUtils.buildVerticalSpacing(8.0),
                  _buildShowModelButton(context),
                ],
              ),
            )),
      ),
    );
  }

  Widget _buildShowModelButton(BuildContext context) {
    return SizedBox(
        height: 30.0,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
            primary: Theme.of(context).primaryColor,
          ),
          child: Text(
            "Exibir Modelo",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ExamModelForm(
                      isEdit: true,
                      fromExamSolicitation: false,
                      examModelType: this.widget.modelTitle,
                      examModelFields: this.widget.modelFields,
                      refreshExamModels: this.widget.refreshModels,
                    )));
          },
        ));
  }
}
