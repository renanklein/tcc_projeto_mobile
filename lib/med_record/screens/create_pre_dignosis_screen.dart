import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcc_projeto_app/pacient/models/appointment_model.dart';
import 'package:tcc_projeto_app/utils/slt_pattern.dart';
import 'package:tcc_projeto_app/med_record/blocs/med_record_bloc.dart';
import 'package:tcc_projeto_app/med_record/repositories/med_record_repository.dart';
import 'package:tcc_projeto_app/pacient/models/pacient_model.dart';
import 'package:tcc_projeto_app/utils/dialog_utils/dialog_widgets.dart';
import 'package:tcc_projeto_app/utils/function_text_form_field.dart';

class CreatePreDiagnosisScreen extends StatefulWidget {
  final PacientModel pacient;
  final AppointmentModel appointmentModel;

  CreatePreDiagnosisScreen(
      {@required this.pacient, @required this.appointmentModel});
  @override
  _CreatePreDiagnosisScreenState createState() =>
      _CreatePreDiagnosisScreenState();
}

class _CreatePreDiagnosisScreenState extends State<CreatePreDiagnosisScreen> {
  MedRecordBloc _medRecordBloc;
  MedRecordRepository _medRecordRepository;

  PacientModel get pacient => this.widget.pacient;
  AppointmentModel get appointmentModel => this.widget.appointmentModel;

  final _preDiagnosisFormKey = new GlobalKey<FormState>();

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  double imcController = 0;
  Widget showImc = Text('');

  final pesoController = TextEditingController();
  final alturaController = TextEditingController();
  final pASistolicaController = TextEditingController();
  final pADiastolicaController = TextEditingController();
  final freqCardiacaController = TextEditingController();
  final freqRepousoController = TextEditingController();
  final temperaturaController = TextEditingController();
  final glicemiaController = TextEditingController();
  final obsController = TextEditingController();

  //apenas para mulheres DUM e DPP
  final dtUltimaMestruacaoController = TextEditingController();
  final dtProvavelPartoController = TextEditingController();

  @override
  void initState() {
    this._medRecordBloc = BlocProvider.of<MedRecordBloc>(context);
    var pacientHash =
        SltPattern.retrivepacientHash(pacient.getCpf, pacient.getSalt);

    this._medRecordBloc.medRecordRepository.setPacientHash = pacientHash;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de pré-diagnostico"),
        centerTitle: true,
      ),
      key: _scaffoldKey,
      body: BlocProvider<MedRecordBloc>(
        create: (context) => this._medRecordBloc,
        child: BlocListener<MedRecordBloc, MedRecordState>(
          listener: (context, state) {
            if (state is MedRecordEventSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                messageSnackBar(
                  context,
                  "Pré-Diagnóstico Cadastrado com Sucesso",
                  Colors.green,
                  Colors.white,
                ),
              );
            }
          },
          child: BlocBuilder<MedRecordBloc, MedRecordState>(
            builder: (context, state) {
              return SafeArea(
                child: Form(
                  key: _preDiagnosisFormKey,
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.lightBlue[100],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Cadastrar Pré-Diagnóstico',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),
                          FunctionTextFormField(
                            controller: pesoController,
                            label: 'Peso',
                            hint: 'Insira o peso do paciente',
                            errorText: 'Por Favor, Insira o peso do paciente',
                            onChangedFunction: (value) {
                              if (int.parse(pesoController.text) > 0 &&
                                  int.parse(alturaController.text) > 0) {
                                setState(() {
                                  imcController =
                                      int.parse(pesoController.text) /
                                          ((int.parse(alturaController.text) *
                                                  int.parse(
                                                      alturaController.text)) /
                                              10000);
                                  showImc = Text('IMC: ' +
                                      imcController.toStringAsFixed(1));
                                });
                              }
                            },
                            validatorFunction: (value) {
                              if (isNumeric(pesoController.text) &&
                                  isNumeric(alturaController.text)) {
                                return null;
                              }

                              return "Por favor insira valores numéricos para Peso e altura";
                            },
                            isNumber: true,
                          ),
                          FunctionTextFormField(
                            controller: alturaController,
                            label: 'Altura em cm',
                            hint: 'Insira a altura do paciente em cm',
                            errorText: 'Por Favor, Insira a altura do paciente',
                            onChangedFunction: (value) {
                              if (int.parse(pesoController.text) > 0 &&
                                  int.parse(alturaController.text) > 0) {
                                setState(() {
                                  imcController =
                                      int.parse(pesoController.text) /
                                          ((int.parse(alturaController.text) *
                                                  int.parse(
                                                      alturaController.text)) /
                                              10000);
                                  showImc = Text('IMC: ' +
                                      imcController.toStringAsFixed(1));
                                });
                              }
                            },
                            validatorFunction: (value) {
                              if (isNumeric(pesoController.text) &&
                                  isNumeric(alturaController.text)) {
                                return null;
                              }

                              return "Por favor insira um valor numérico para altura";
                            },
                            isNumber: true,
                          ),
                          showImc,
                          FunctionTextFormField(
                            controller: pASistolicaController,
                            label: 'P.A.',
                            hint:
                                'Insira o valor da Pressão Artorial do paciente',
                            errorText: 'Por Favor, Insira um valor para a P.A.',
                            onChangedFunction: (value) {},
                            validatorFunction: (value) {
                              if (isNumeric(pASistolicaController.text)) {
                                return null;
                              }

                              return "Por favor insira um valor numérico para P.A";
                            },
                            isNumber: true,
                          ),
                          FunctionTextFormField(
                            controller: pADiastolicaController,
                            label: 'P.D.',
                            hint:
                                'Insira o valor da Pressão Diastólica do paciente',
                            errorText: 'Por Favor, Insira um valor para a P.D.',
                            onChangedFunction: (value) {},
                            validatorFunction: (value) {
                              if (isNumeric(pADiastolicaController.text)) {
                                return null;
                              }

                              return "Por favor insira um valor numérico para P.D";
                            },
                            isNumber: true,
                          ),
                          FunctionTextFormField(
                            controller: freqCardiacaController,
                            label: 'Freq. Cardíaca',
                            hint:
                                'Insira o valor da Frequência Cardíaca do paciente',
                            errorText: 'Por Favor, Insira um valor para a F.C.',
                            onChangedFunction: (value) {},
                            validatorFunction: (value) {
                              if (isNumeric(freqCardiacaController.text)) {
                                return null;
                              }

                              return "Por favor insira um valor numérico para Freq. Cardíaca";
                            },
                            isNumber: true,
                          ),
                          FunctionTextFormField(
                            controller: freqRepousoController,
                            label: 'Freq. Repouso',
                            hint:
                                'Insira o valor da Frequência de Repouso do paciente',
                            errorText:
                                'Por Favor, Insira um valor para a Freq. Repouso',
                            onChangedFunction: (value) {},
                            validatorFunction: (value) {
                              if (isNumeric(freqRepousoController.text)) {
                                return null;
                              }

                              return "Por favor insira um valor numérico para Freq. Repouso";
                            },
                            isNumber: true,
                          ),
                          FunctionTextFormField(
                            controller: temperaturaController,
                            label: 'Temperatura',
                            hint: 'Insira o valor da Temperatura do paciente',
                            errorText: 'Por Favor, Insira a temperatura',
                            onChangedFunction: (value) {},
                            validatorFunction: (value) {
                              if (isNumeric(temperaturaController.text)) {
                                return null;
                              }

                              return "Por favor insira um valor numérico para temperatura";
                            },
                            isNumber: true,
                          ),
                          FunctionTextFormField(
                            controller: glicemiaController,
                            label: 'Glicemia',
                            hint: 'Insira o valor da Glicemia do paciente',
                            errorText: 'Por Favor, Insira o valor da Glicemia',
                            onChangedFunction: (value) {},
                            validatorFunction: (value) {
                              if (isNumeric(glicemiaController.text)) {
                                return null;
                              }

                              return "Por favor insira um valor numérico para temperatura";
                            },
                            isNumber: true,
                          ),
                          //formFieldFemalePacient(),
                          FunctionTextFormField(
                            controller: obsController,
                            label: 'Observações',
                            hint: 'Observações',
                            errorText: '',
                            onChangedFunction: (value) {},
                            validatorFunction: (value) {},
                            isNumber: false,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MaterialButton(
                              color: Color(0xFF84FFFF),
                              height: 55.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              onPressed: () async {
                                if (_preDiagnosisFormKey.currentState
                                    .validate()) {
                                  this._medRecordBloc.add(
                                        PreDiagnosisCreateButtonPressed(
                                            peso: pesoController.text,
                                            altura: alturaController.text,
                                            imc: '28.5',
                                            pASistolica:
                                                pASistolicaController.text,
                                            pADiastolica:
                                                pADiastolicaController.text,
                                            freqCardiaca:
                                                freqCardiacaController.text,
                                            freqRepouso:
                                                freqRepousoController.text,
                                            temperatura:
                                                temperaturaController.text,
                                            glicemia: glicemiaController.text,
                                            obs: obsController.text,
                                            dtUltimaMestruacao:
                                                dtUltimaMestruacaoController
                                                    .text,
                                            dtProvavelParto:
                                                dtProvavelPartoController.text,
                                            dtAppointmentEvent: this
                                                .appointmentModel
                                                .appointmentDate),
                                      );
                                }
                              },
                              child: Text('Cadastrar Pré-Atendimento'),
                            ),
                          ),
                        ]),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  bool isNumeric(String s) {
    if (s == null) return false;

    return double.tryParse(s) != null;
  }

  Widget formFieldFemalePacient() {
    if (pacient.getSexo == 'Feminino') {
      return Column(
        children: [
          FunctionTextFormField(
            controller: dtUltimaMestruacaoController,
            label: 'Data da última mestruação',
            hint: 'Insira a data da última mestruação da paciente',
            errorText: 'Por Favor, Insira a data da última mestruação',
            onChangedFunction: null,
            validatorFunction: (value) {},
            isNumber: false,
          ),
          FunctionTextFormField(
              controller: dtProvavelPartoController,
              label: 'Data provavél do parto',
              hint: 'Insira a data provavél do parto',
              errorText: 'Por Favor, Insira a data provavél do parto',
              onChangedFunction: null,
              validatorFunction: (value) {},
              isNumber: false)
        ],
      );
    } else
      return Row();
  }
}
