import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/exams/blocs/exam_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcc_projeto_app/med_record/blocs/med_record_bloc.dart';
import 'package:tcc_projeto_app/utils/datetime_form_field.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';
import 'package:tcc_projeto_app/utils/text_form_field.dart';

class ExamSolicitationFormScreen extends StatefulWidget {
  const ExamSolicitationFormScreen({Key key}) : super(key: key);

  @override
  _ExamSolicitationFormScreenState createState() =>
      _ExamSolicitationFormScreenState();
}

class _ExamSolicitationFormScreenState
    extends State<ExamSolicitationFormScreen> {
  ExamBloc _examBloc;
  MedRecordBloc _medRecordBloc;
  List<String> _examModelsTypes = <String>[];
  DateTime _examSolicitationDate = DateTime.now();
  TextEditingController _exanModelTypeController = TextEditingController();
  TextEditingController _examDateController = TextEditingController();
  String currentItem;
  @override
  void initState() {
    this._examBloc = context.read<ExamBloc>();
    this._medRecordBloc = context.read<MedRecordBloc>();
    this._medRecordBloc.add(LoadExamModels());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MedRecordBloc, MedRecordState>(
            bloc: this._medRecordBloc,
            listener: (context, state) {
              if (state is LoadExamModelSuccess) {
                state.models['models'].forEach((model) {
                  this._examModelsTypes.add(model["Tipo de Exame"]);
                  this.currentItem = this._examModelsTypes.first;
                });
              }
            }),
        BlocListener<ExamBloc, ExamState>(
            bloc: this._examBloc, listener: (context, state) {})
      ],
      child: BlocBuilder<MedRecordBloc, MedRecordState>(
        builder: (context, state) {
          if (state is LoadExamModelProcessing) {
            return LayoutUtils.buildCircularProgressIndicator(context);
          }

          return BlocBuilder<ExamBloc, ExamState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Expanded(
                    child: Form(
                  child: ListView(
                    children: [
                      _buildDropdownExamModelTypeButton(),
                      DateTimeFormField(
                          dateTimeController: _examDateController,
                          fieldPlaceholder: "Data da solicitação"),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0)
                          ),
                          primary: Theme.of(context).primaryColor
                        ),
                          onPressed: () {
                            this._examBloc.add(CreateExamSolicitation());
                          },
                          child: Text(
                            "Criar Solicitação",
                            style: TextStyle(
                              fontSize: 17.0,
                              color: Colors.white
                            ),
                          ))
                    ],
                  ),
                )),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDropdownExamModelTypeButton() {
    return Container(
      alignment: Alignment.center,
      child: DropdownButton<String>(
        items: this._examModelsTypes.map((el) {
          return DropdownMenuItem(value: el, child: Text(el));
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            this._exanModelTypeController.text = newValue;
            this.currentItem = newValue;
          });
        },
        value: this.currentItem,
      ),
    );
  }
}
