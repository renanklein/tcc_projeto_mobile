import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcc_projeto_app/exams/blocs/exam_bloc.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/exams/repositories/exam_repository.dart';

class ExamModelExclude extends StatefulWidget {
  final examModelsToBeExcluded;
  final refreshModels;

  ExamModelExclude(
      {@required this.examModelsToBeExcluded, @required this.refreshModels});

  @override
  _ExamModelExcludeState createState() => _ExamModelExcludeState();
}

class _ExamModelExcludeState extends State<ExamModelExclude> {
  ExamBloc examBloc;
  List get examModelsToBeExcluded => this.widget.examModelsToBeExcluded;
  Function get refreshModels => this.widget.refreshModels;

  @override
  void initState() {
    this.examBloc =
        ExamBloc(examRepository: Injector.appInstance.get<ExamRepository>());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 5, left: 15.0, right: 15.0, bottom: 20.0),
        padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
        height: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: BlocProvider(
          create: (context) => this.examBloc,
          child: BlocListener<ExamBloc, ExamState>(
            listener: (context, state) {
              if (state is DeleteExamModelSuccess) {
                Future.delayed(Duration(seconds: 1));
                Navigator.of(context).pop();
                this.refreshModels();
              }
            },
            child: BlocBuilder<ExamBloc, ExamState>(
              bloc: this.examBloc,
              builder: (context, state) {
                if (state is DeleteExamModelProcessing) {
                  return LayoutUtils.buildCircularProgressIndicator(context);
                }
                return Form(
                    child: ListView(
                  children: <Widget>[
                    LayoutUtils.buildVerticalSpacing(28.0),
                    Center(
                      child: Text(
                        "Deseja excluir os modelos ?",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _buildCancelButton(),
                        _buildConfirmButtom()
                      ],
                    )
                  ],
                ));
              },
            ),
          ),
        ));
  }

  Widget _buildConfirmButtom() {
    return Padding(
      padding: EdgeInsets.only(right: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.red,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        child: Text(
          "Excluir",
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
        ),
        onPressed: () {
          this.examBloc.add(
              DeleteExamModel(modelsToBeRemoved: this.examModelsToBeExcluded));
        },
      ),
    );
  }

  Widget _buildCancelButton() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          primary: Colors.grey,
        ),
        child: Text(
          "Cancelar",
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
