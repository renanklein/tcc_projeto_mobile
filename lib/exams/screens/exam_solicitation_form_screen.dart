import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/exams/blocs/exam_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcc_projeto_app/med_record/blocs/med_record_bloc.dart';
import 'package:tcc_projeto_app/med_record/screens/list_med_record_screen.dart';
import 'package:tcc_projeto_app/pacient/models/pacient_model.dart';
import 'package:tcc_projeto_app/routes/medRecordArguments.dart';
import 'package:tcc_projeto_app/utils/datetime_form_field.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';
import 'package:tcc_projeto_app/utils/slt_pattern.dart';

class ExamSolicitationFormScreen extends StatefulWidget {
  final PacientModel pacient;

  ExamSolicitationFormScreen({@required this.pacient});

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
  TextEditingController _examModelTypeController = TextEditingController();
  TextEditingController _examDateController = TextEditingController();
  String currentItem;

  PacientModel get pacient => this.widget.pacient;

  @override
  void initState() {
    this._examBloc = context.read<ExamBloc>();
    this._medRecordBloc = context.read<MedRecordBloc>();
    this._medRecordBloc.add(LoadExamModels());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Solicitação de exame"),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<MedRecordBloc, MedRecordState>(
              bloc: this._medRecordBloc,
              listener: (context, state) {
                if (state is LoadExamModelSuccess) {
                  state.models['models'].forEach((model) {
                    this._examModelsTypes.add(model["Tipo de Exame"]);
                    this.currentItem = this._examModelsTypes.first;
                    this._examModelTypeController.text = this.currentItem;
                  });
                }
              }),
          BlocListener<ExamBloc, ExamState>(
              bloc: this._examBloc,
              listener: (context, state) {
                if (state is ExamSolicitationSuccess) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => MedRecordScreen(
                          medRecordArguments: MedRecordArguments(
                            pacientModel: this.pacient,
                            index: "4"
                          ))));
                }
              })
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
                  child: Form(
                    child: ListView(
                      children: [
                        Center(
                            child: Text(
                          "Selecione o modelo de exame",
                          style: TextStyle(fontSize: 15.0),
                        )),
                        LayoutUtils.buildVerticalSpacing(5.0),
                        _buildDropdownExamModelTypeButton(),
                        LayoutUtils.buildVerticalSpacing(10.0),
                        DateTimeFormField(
                            dateTimeController: _examDateController,
                            fieldPlaceholder: "Data da solicitação"),
                        LayoutUtils.buildVerticalSpacing(10.0),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0)),
                                primary: Theme.of(context).primaryColor),
                            onPressed: () {
                              var pacientHash = SltPattern.retrivepacientHash(
                                  this.pacient.getCpf, this.pacient.getSalt);
                              this._examBloc.add(CreateExamSolicitation(
                                  solicitationDate:
                                      this._examDateController.text,
                                  solicitationExamType:
                                      this._examModelTypeController.text,
                                  pacientHash: pacientHash));
                            },
                            child: Text(
                              "Criar Solicitação",
                              style: TextStyle(
                                  fontSize: 17.0, color: Colors.white),
                            ))
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
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
            this._examModelTypeController.text = newValue;
            this.currentItem = newValue;
          });
        },
        value: this.currentItem,
      ),
    );
  }
}
