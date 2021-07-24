import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/exams/models/exam_solicitation_model.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

class ExamSolicitationCard extends StatelessWidget{
  final ExamSolicitationModel examSolicitationModel;

  ExamSolicitationCard({@required this.examSolicitationModel});
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
          _buildExamSolicitationDetailsButton()
        ],
      )
    );
  }

  Widget _buildExamSolicitationDetailsButton(){
    return Container();
  }
}