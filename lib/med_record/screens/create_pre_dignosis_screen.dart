import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/login/models/user_model.dart';
import 'package:tcc_projeto_app/pacient/models/appointment_model.dart';
import 'package:tcc_projeto_app/pacient/screens/appointments_wait_list_screen.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';
import 'package:tcc_projeto_app/utils/slt_pattern.dart';
import 'package:tcc_projeto_app/med_record/blocs/med_record_bloc.dart';
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
  //MedRecordRepository _medRecordRepository;

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
  String imc = "";
  String weight = "";
  String height = "";

  @override
  void initState() {
    this._medRecordBloc = context.read<MedRecordBloc>();
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
      body: BlocListener<MedRecordBloc, MedRecordState>(
        bloc: this._medRecordBloc,
        listener: (context, state) {
          if (state is PreDiagnosisCreateOrUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              messageSnackBar(
                context,
                "Pré-Diagnóstico Cadastrado com Sucesso",
                Colors.green,
                Colors.white,
              ),
            );

            var user = Injector.appInstance.get<UserModel>();
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AppointmentsWaitListScreen(
                      userUid: user.uid,
                    )));
          }
        },
        child: BlocBuilder<MedRecordBloc, MedRecordState>(
          bloc: this._medRecordBloc,
          builder: (context, state) {
            if (state is MedRecordEventProcessing) {
              return LayoutUtils.buildCircularProgressIndicator(context);
            } else {
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
                            label: 'Peso em kg',
                            hint: 'Insira o peso do paciente',
                            errorText: 'Por Favor, Insira o peso do paciente',
                            onChangedFunction: (value) {
                              this.onChangedIMCFields();
                            },
                            validatorFunction: (value) {},
                            isNumber: true,
                          ),
                          FunctionTextFormField(
                            controller: alturaController,
                            label: 'Altura em cm',
                            hint: 'Insira a altura do paciente em cm',
                            errorText: 'Por Favor, Insira a altura do paciente',
                            onChangedFunction: (value) {
                              this.onChangedIMCFields();
                            },
                            validatorFunction: (value) {},
                            isNumber: true,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black54,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: Center(child: showImc)),
                          ),
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
                            controller: temperaturaController,
                            label: 'Temperatura',
                            hint: 'Insira o valor da Temperatura do paciente',
                            errorText: 'Por Favor, Insira a temperatura',
                            onChangedFunction: (value) {},
                            validatorFunction: (value) {},
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
                            validatorFunction: (value) {},
                            isNumber: true,
                          ),
                          FunctionTextFormField(
                            controller: glicemiaController,
                            label: 'Glicemia',
                            hint: 'Insira o valor da Glicemia do paciente',
                            errorText: 'Por Favor, Insira o valor da Glicemia',
                            onChangedFunction: (value) {},
                            validatorFunction: (value) {},
                            isNumber: true,
                          ),
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
                              onPressed: () {
                                if (_preDiagnosisFormKey.currentState
                                    .validate()) {
                                  this._medRecordBloc.add(
                                        PreDiagnosisCreateOrUpdateButtonPressed(
                                            isUpdate: false,
                                            peso: double.parse(this.weight),
                                            altura: double.parse(this.height),
                                            imc: this.imcController,
                                            pASistolica: int.parse(
                                                pASistolicaController.text),
                                            pADiastolica: int.parse(
                                                pADiastolicaController.text),
                                            freqCardiaca: int.parse(
                                                freqCardiacaController.text),
                                            freqRepouso: int.tryParse(
                                                freqRepousoController.text),
                                            temperatura: double.tryParse(
                                                temperaturaController.text),
                                            glicemia: int.tryParse(
                                                glicemiaController.text),
                                            appointment: this.appointmentModel,
                                            obs: obsController.text,
                                            dtUltimaMestruacao:
                                                dtUltimaMestruacaoController
                                                    .text,
                                            dtProvavelParto:
                                                dtProvavelPartoController.text,
                                            dtPrediagnosis: this
                                                .appointmentModel
                                                .appointmentDate,
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
            }
          },
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

  void onChangedIMCFields() {
    this.weight = pesoController.text.contains(",")
        ? pesoController.text.split(',').join('.')
        : pesoController.text;
    this.height = alturaController.text.contains(",")
        ? alturaController.text.split(',').join('.')
        : alturaController.text;

    if (double.tryParse(weight) != null &&
        (double.tryParse(height) != null && double.tryParse(height) > 0)) {
      setState(
        () {
          var parsedWeight = double.tryParse(weight);
          var parsedHeight = double.tryParse(height) / 100;

          imcController = parsedWeight / (parsedHeight * parsedHeight);
          showImc = Text(
            'IMC: ' + imcController.toStringAsFixed(1),
            style: TextStyle(fontSize: 22),
          );
        },
      );
    }
  }
}
