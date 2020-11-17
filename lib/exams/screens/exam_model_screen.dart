import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcc_projeto_app/exams/blocs/exam_bloc.dart';
import 'package:tcc_projeto_app/exams/models/exam_details.dart';
import 'package:tcc_projeto_app/exams/screens/exam_model_form.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

class ExamModelScreen extends StatefulWidget {
  @override
  _ExamModelScreenState createState() => _ExamModelScreenState();
}

class _ExamModelScreenState extends State<ExamModelScreen> {
  ExamBloc _examBloc;
  List<Widget> modelFieldsFromDatabase = [];
  List<Map> modelTypeEntries;

  @override
  void initState() {
    this._examBloc = BlocProvider.of<ExamBloc>(context);
    this._examBloc.add(LoadExamModels());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Modelos de exame"),
          centerTitle: true,
        ),
        body: BlocListener<ExamBloc, ExamState>(
          listener: (context, state) => {
            if (state is LoadExamModelSuccess)
              {
                state.models.forEach((key, value) {
                  if (key == "Tipo de Exame") {
                    this.modelTypeEntries.add({key: value});
                  }
                })
              }
          },
          child: BlocBuilder<ExamBloc, ExamState>(
            builder: (context, state) {
              if (state is LoadExamModelProcessing) {
                return LayoutUtils.buildCircularProgressIndicator(context);
              }
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListView(shrinkWrap: true, children: <Widget>[
                  ..._buildModelFormBody(),
                  _buildRouteModelExamFormButton()
                ]),
              );
            },
          ),
        ));
  }

  List<Widget> _buildModelFormBody() {
    if (this.modelFieldsFromDatabase.isEmpty) {
      return <Widget>[
        Center(
          child: Text("Não há modelos cadastrados",
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 16.0)),
        )
      ];
    }

    return <Widget>[...this.modelFieldsFromDatabase];
  }

  Widget _buildRouteModelExamFormButton() {
    return RaisedButton(
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ExamModelForm()));
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32.0),
      ),
      color: Theme.of(context).primaryColor,
      child: Text(
        "Formulário de cadastro de modelo",
        style: TextStyle(
            fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
