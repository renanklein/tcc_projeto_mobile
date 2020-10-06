import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/med_record/blocs/med_record_bloc.dart';
import 'package:tcc_projeto_app/med_record/repositories/med_record_repository.dart';
import 'package:tcc_projeto_app/utils/dialog_utils/dialog_widgets.dart';

class CreateDiagnosisScreen extends StatefulWidget {
  @override
  _CreateDiagnosisScreenState createState() => _CreateDiagnosisScreenState();
}

class _CreateDiagnosisScreenState extends State<CreateDiagnosisScreen> {
  MedRecordBloc _medRecordBloc;
  MedRecordRepository _medRecordRepository;

  final diagnosisFormKey = new GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _diagnosisScreenKey = GlobalKey<FormState>();
  final problemIdController = TextEditingController();
  final problemDescriptionController = TextEditingController();
  final diagnosisCidController = TextEditingController();
  final diagnosisDescriptionController = TextEditingController();
  final prescriptionMedicineController = TextEditingController();
  final prescriptionDosageController = TextEditingController();
  final prescriptionDosageFormController = TextEditingController();
  final prescriptionUsageOrientationController = TextEditingController();
  final prescriptionUsageDurationController = TextEditingController();

  @override
  void initState() {
    var injector = Injector.appInstance;
    this._medRecordRepository = injector.getDependency<MedRecordRepository>();

    this._medRecordBloc = new MedRecordBloc(
      medRecordRepository: this._medRecordRepository,
    );

    super.initState();
  }

  @override
  void dispose() {
    problemIdController.dispose();
    problemDescriptionController.dispose();
    diagnosisCidController.dispose();
    diagnosisDescriptionController.dispose();
    prescriptionMedicineController.dispose();
    prescriptionDosageController.dispose();
    prescriptionDosageFormController.dispose();
    prescriptionUsageOrientationController.dispose();
    prescriptionUsageDurationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: BlocProvider<MedRecordBloc>(
        create: (context) => this._medRecordBloc,
        child: BlocListener<MedRecordBloc, MedRecordState>(
          listener: (context, state) {
            if (state is MedRecordEventSuccess) {
              this._scaffoldKey.currentState.showSnackBar(messageSnackBar(
                    context,
                    "Diagnóstico Cadastrado com Sucesso",
                    Colors.green,
                    Colors.white,
                  ));
            }
          },
          child: BlocBuilder<MedRecordBloc, MedRecordState>(
              builder: (context, state) {
            //if (state is ) {}

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
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.lightBlue[100],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Cadastrar Diagnóstico',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: ListView(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                      0,
                                      0,
                                      0,
                                      4,
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                            0,
                                            5,
                                            0,
                                            0,
                                          ),
                                          child: Text(
                                            'Relato da Queixa',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17.0,
                                            ),
                                          ),
                                        ),
                                        _diagnosisFormField(
                                          problemDescriptionController,
                                          'Queixa:',
                                          'Descreva o problema relatado pelo paciente',
                                          'Por Favor, descreva o problema',
                                        ),
                                        _diagnosisFormField(
                                          problemIdController,
                                          'Id da Queixa:',
                                          'Digite um Número para indicar problemas relacionados',
                                          'Por Favor, digite algum número',
                                        ),
                                      ],
                                    ),
                                  ),
                                  breakLine(),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                      0,
                                      0,
                                      0,
                                      4,
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                            0,
                                            5,
                                            0,
                                            0,
                                          ),
                                          child: Text(
                                            'Diagnóstico',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17.0,
                                            ),
                                          ),
                                        ),
                                        _diagnosisFormField(
                                          diagnosisDescriptionController,
                                          'Descrição de Diagnóstico:',
                                          'Descreva o diagnóstico encontrado para o paciente',
                                          'Por Favor, descreva o diagnóstico',
                                        ),
                                        _diagnosisFormField(
                                          diagnosisCidController,
                                          'CID:',
                                          'Digite o CID do Diagnóstico',
                                          'Por Favor, digite o CID',
                                        ),
                                      ],
                                    ),
                                  ),
                                  breakLine(),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                      0,
                                      0,
                                      0,
                                      4,
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                            0,
                                            5,
                                            0,
                                            0,
                                          ),
                                          child: Text(
                                            'Prescrição',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17.0,
                                            ),
                                          ),
                                        ),
                                        _diagnosisFormField(
                                          prescriptionMedicineController,
                                          'Remédio:',
                                          'Digite o nome do Remédio',
                                          'Por Favor, Digite o nome do Remédio',
                                        ),
                                        _diagnosisFormField(
                                          prescriptionDosageController,
                                          'Dosagem do Remédio:',
                                          'Digite a dosagem do Remédio',
                                          'Por Favor, Digite a dosagem do Remédio',
                                        ),
                                        _diagnosisFormField(
                                          prescriptionDosageFormController,
                                          'Via de Uso:',
                                          'Descreva a via de uso do remédio',
                                          'Por Favor, digite a via de uso do remédio',
                                        ),
                                        _diagnosisFormField(
                                          prescriptionUsageDurationController,
                                          'Duração de uso do remédio:',
                                          'Digite a quantidade de dias de uso do remédio',
                                          'Por Favor, Digite a duração de uso do remédio',
                                        ),
                                        _diagnosisFormField(
                                          prescriptionUsageOrientationController,
                                          'Orientação de uso do remédio:',
                                          'Digite a orientação de uso do remédio',
                                          'Por Favor, Digite a orientação de uso do remédio',
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: MaterialButton(
                                      color: Color(0xFF84FFFF),
                                      height: 55.0,
                                      shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(15.0),
                                      ),
                                      onPressed: () async {
                                        if (_diagnosisScreenKey.currentState
                                            .validate()) {
                                          _medRecordBloc.add(
                                            DiagnosisCreateButtonPressed(
                                              problemId:
                                                  problemIdController.text,
                                              problemDescription:
                                                  problemDescriptionController
                                                      .text,
                                              diagnosisCid:
                                                  diagnosisCidController.text,
                                              diagnosisDescription:
                                                  diagnosisDescriptionController
                                                      .text,
                                              prescriptionMedicine:
                                                  prescriptionMedicineController
                                                      .text,
                                              prescriptionDosage:
                                                  prescriptionDosageController
                                                      .text,
                                              prescriptionDosageForm:
                                                  prescriptionDosageFormController
                                                      .text,
                                              prescriptionUsageOrientation:
                                                  prescriptionUsageOrientationController
                                                      .text,
                                              prescriptionUsageDuration:
                                                  prescriptionUsageDurationController
                                                      .text,
                                            ),
                                          );
                                        }
                                        if (state is MedRecordEventSuccess) {
                                          messageSnackBar(
                                            context,
                                            'Diagnóstico Cadastrado com Sucesso',
                                            Colors.green,
                                            Colors.white,
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
          }),
        ),
      ),
    );
  }
}

Widget _diagnosisFormField(controller, label, hint, errorText) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        labelText: label,
        hintText: hint,
      ),
      minLines: 1,
      maxLines: 8,
      validator: (value) {
        if (value.isEmpty) {
          return errorText;
        }
        return null;
      },
    ),
  );
}

Widget breakLine() {
  return Container(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        width: 1,
        color: Colors.black,
      ))));
}
