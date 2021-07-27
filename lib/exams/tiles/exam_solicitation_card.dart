import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/exams/models/exam_solicitation_model.dart';
import 'package:tcc_projeto_app/exams/screens/exam_solicitation_detail_screen.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

class ExamSolicitationCard extends StatelessWidget{
  final String pacientHash;
  final ExamSolicitationModel examSolicitationModel;

  ExamSolicitationCard({@required this.examSolicitationModel, @required this.pacientHash});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4.0,
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32.0)
      ),

      child: Column(
        children: [
          Text(
            this.examSolicitationModel.examTypeModel,
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
          LayoutUtils.buildVerticalSpacing(8.0),
          Text(
            this.examSolicitationModel.solicitationDate,
            style: TextStyle(
              fontSize: 14.0
            ),
          ),

          LayoutUtils.buildVerticalSpacing(8.0),
          Text(
            this.examSolicitationModel.status,
            style: TextStyle(
              fontSize: 14.0
            ),
          ),
          _buildExamSolicitationDetailsButton(context)
        ],
      )
    );
  }

  Widget _buildExamSolicitationDetailsButton(BuildContext context){
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0)),
            primary: Theme.of(context).primaryColor),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ExamSolicitationDetailScreen(
                pacientHash: this.pacientHash,
                examSolicitationModel: this.examSolicitationModel,
                examSolicitationId: this.examSolicitationModel.id,
              )));
        },
        child: Text(
          "Detalhes",
          style: TextStyle(fontSize: 17.0, color: Colors.white),
        ));
  }
}