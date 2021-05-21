import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:intl/intl.dart';
import 'package:tcc_projeto_app/med_record/blocs/med_record_bloc.dart';
import 'package:tcc_projeto_app/med_record/repositories/med_record_repository.dart';
import 'package:tcc_projeto_app/med_record/style/med_record_style.dart';
import 'package:tcc_projeto_app/utils/dialog_utils/dialog_widgets.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

class CreateDiagnosisScreen extends StatefulWidget {
  @override
  _CreateDiagnosisScreenState createState() => _CreateDiagnosisScreenState();
}

class _CreateDiagnosisScreenState extends State<CreateDiagnosisScreen> {
  MedRecordBloc _medRecordBloc;
  MedRecordRepository _medRecordRepository;
  MedRecordStyle _medRecordStyle = new MedRecordStyle();

  static List<String> diagnosisDescriptionList = [null];
  static List<String> diagnosisCidList = [null];

  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _diagnosisScreenKey = new GlobalKey<FormState>();

  final problemIdController = TextEditingController();
  final problemDescriptionController = TextEditingController();
  final prescriptionController = TextEditingController();

  @override
  void initState() {
    var injector = Injector.appInstance;
    this._medRecordRepository = injector.get<MedRecordRepository>();

    this._medRecordBloc = new MedRecordBloc(
      medRecordRepository: this._medRecordRepository,
    );

    super.initState();
  }

  @override
  void dispose() {
    problemIdController.dispose();
    problemDescriptionController.dispose();
    prescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Cadastrar diagnóstico"),
        elevation: 0.0,
      ),
      body: BlocProvider<MedRecordBloc>(
        create: (context) => this._medRecordBloc,
        child: BlocListener<MedRecordBloc, MedRecordState>(
          listener: (context, state) {
            if (state is DiagnosisCreateOrUpdateSuccess) {
              diagnosisDescriptionList = [null];
              diagnosisCidList = [null];
              ScaffoldMessenger.of(context).showSnackBar(
                messageSnackBar(
                  context,
                  "Diagnóstico Cadastrado com Sucesso",
                  Colors.green,
                  Colors.white,
                ),
              );

              Navigator.of(context).pop();
            }
          },
          child: BlocBuilder<MedRecordBloc, MedRecordState>(
              builder: (context, state) {
            if (state is MedRecordEventProcessing) {
              return LayoutUtils.buildCircularProgressIndicator(context);
            } else {
              return SafeArea(
                child: Form(
                  key: _diagnosisScreenKey,
                  child: Center(
                    child: Container(
                      //decoration: new BoxDecoration(color: Colors.black54),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.98,
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: <Widget>[
                              Flexible(
                                child: ListView(
                                  children: <Widget>[
                                    Container(
                                      margin: _medRecordStyle.containerMargin,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding:
                                                _medRecordStyle.formTextPadding,
                                            child: Text(
                                              'Relato da Queixa',
                                              textAlign: TextAlign.center,
                                              style:
                                                  _medRecordStyle.formTextStyle,
                                            ),
                                          ),
                                          _diagnosisFormField(
                                            problemIdController,
                                            'Id da Queixa:',
                                            'Digite um Número para indicar problemas relacionados',
                                            'Por Favor, digite algum número',
                                            null,
                                            keyboardType: TextInputType.number,
                                          ),
                                          _diagnosisFormField(
                                            problemDescriptionController,
                                            'Queixa:',
                                            'Descreva o problema relatado pelo paciente',
                                            'Por Favor, descreva o problema',
                                            null,
                                          ),
                                        ],
                                      ),
                                    ),
                                    _medRecordStyle.breakLine(),
                                    Container(
                                      margin: _medRecordStyle.containerMargin,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding:
                                                _medRecordStyle.formTextPadding,
                                            child: Text(
                                              'Diagnóstico',
                                              textAlign: TextAlign.center,
                                              style:
                                                  _medRecordStyle.formTextStyle,
                                            ),
                                          ),
                                          ..._getDiagnosisFields(),
                                        ],
                                      ),
                                    ),
                                    _medRecordStyle.breakLine(),
                                    Container(
                                      margin: _medRecordStyle.containerMargin,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding:
                                                _medRecordStyle.formTextPadding,
                                            child: Text(
                                              'Prescrição',
                                              textAlign: TextAlign.center,
                                              style:
                                                  _medRecordStyle.formTextStyle,
                                            ),
                                          ),
                                          _diagnosisFormField(
                                            prescriptionController,
                                            'Prescrição:',
                                            'Digite os detalhes da prescrição',
                                            'Por Favor, Digite os detalhes da prescrição',
                                            null,
                                            keyboardType:
                                                TextInputType.multiline,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: MaterialButton(
                                        color: Color(0xFF84FFFF),
                                        height: 55.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        onPressed: () async {
                                          if (_diagnosisScreenKey.currentState
                                              .validate()) {
                                            var diagnosisDate = DateTime.now();
                                            var formatter =
                                                DateFormat('dd/MM/yyyy');
                                            var dateAsString =
                                                formatter.format(diagnosisDate);
                                            _medRecordBloc.add(
                                              DiagnosisCreateOrUpdateButtonPressed(
                                                diagnosisDate: dateAsString,
                                                isUpdate: false,
                                                problemId:
                                                    problemIdController.text,
                                                problemDescription:
                                                    problemDescriptionController
                                                        .text,
                                                prescription:
                                                    prescriptionController.text,
                                                diagnosisCid: diagnosisCidList,
                                                diagnosisDescription:
                                                    diagnosisDescriptionList,
                                              ),
                                            );
                                          }
                                        },
                                        child: Text('Cadastrar Diagnóstico'),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ])),
                      ),
                    ),
                  ),
                ),
              );
            }
          }),
        ),
      ),
    );
  }

  List<Widget> _getDiagnosisFields() {
    List<Widget> friendsTextFields = [];
    for (int i = 0; i < diagnosisDescriptionList.length; i++) {
      friendsTextFields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: DiagnosisTextFormField(i)),
            SizedBox(
              width: 16,
            ),
            // we need add button at last friends row
            _addRemoveButton(i == diagnosisDescriptionList.length - 1, i),
          ],
        ),
      ));
    }
    return friendsTextFields;
  }

  Widget _addRemoveButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          diagnosisDescriptionList.insert(0, null);
          diagnosisCidList.insert(0, null);
        } else {
          diagnosisDescriptionList.removeAt(index);
          diagnosisCidList.removeAt(index);
        }

        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }
}

Widget _diagnosisFormField(
    controller, label, hint, errorText, onChangedFunction,
    {TextInputType keyboardType = TextInputType.name}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        labelText: label,
        hintText: hint,
      ),
      minLines: 1,
      maxLines: 10,
      validator: (value) {
        if (value.isEmpty) {
          return errorText;
        }
        return null;
      },
      onChanged: onChangedFunction,
    ),
  );
}

class DiagnosisTextFormField extends StatefulWidget {
  final int index;
  DiagnosisTextFormField(this.index);

  @override
  _DiagnosisTextFormFieldState createState() => _DiagnosisTextFormFieldState();
}

class _DiagnosisTextFormFieldState extends State<DiagnosisTextFormField> {
  TextEditingController _diagnosisController;
  TextEditingController _cidController;

  @override
  void initState() {
    super.initState();
    _diagnosisController = TextEditingController();
    _cidController = TextEditingController();
  }

  @override
  void dispose() {
    _diagnosisController.dispose();
    _cidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _diagnosisController.text =
          _CreateDiagnosisScreenState.diagnosisDescriptionList[widget.index] ??
              '';
      _cidController.text =
          _CreateDiagnosisScreenState.diagnosisCidList[widget.index] ?? '';
    });
    return Column(
      children: [
        _diagnosisFormField(
          _diagnosisController,
          'Descrição do Diagnóstico:',
          'Descreva o diagnóstico encontrado para o paciente',
          'Por Favor, descreva o diagnóstico',
          (v) => _CreateDiagnosisScreenState
              .diagnosisDescriptionList[widget.index] = v,
        ),
        _diagnosisFormField(
          _cidController,
          'CID:',
          'Digite o CID do Diagnóstico',
          'Por Favor, digite o CID',
          (v) => _CreateDiagnosisScreenState.diagnosisCidList[widget.index] = v,
        ),
      ],
    );
  }
}
