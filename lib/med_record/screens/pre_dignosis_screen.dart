import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/med_record/blocs/med_record_bloc.dart';
import 'package:tcc_projeto_app/med_record/repositories/med_record_repository.dart';
import 'package:tcc_projeto_app/pacient/models/pacient_model.dart';

class PreDiagnosisScreen extends StatefulWidget {
  final PacientModel pacient;

  PreDiagnosisScreen({
    @required this.pacient,
  });
  @override
  _PreDiagnosisScreenState createState() => _PreDiagnosisScreenState();
}

class _PreDiagnosisScreenState extends State<PreDiagnosisScreen> {
  MedRecordBloc _medRecordBloc;
  MedRecordRepository _medRecordRepository;

  PacientModel get pacient => this.widget.pacient;

  final _preDiagnosisFormKey = new GlobalKey<FormState>();

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  final pesoController = TextEditingController();
  final alturaController = TextEditingController();
  final imcController = TextEditingController();
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
    var injector = Injector.appInstance;
    this._medRecordRepository = injector.getDependency<MedRecordRepository>();

    this._medRecordBloc = new MedRecordBloc(
      medRecordRepository: this._medRecordRepository,
    );

    super.initState();
  }

  @override
  void dispose() {
    pesoController.dispose();
    alturaController.dispose();
    imcController.dispose();
    pASistolicaController.dispose();
    pADiastolicaController.dispose();
    freqCardiacaController.dispose();
    freqRepousoController.dispose();
    temperaturaController.dispose();
    glicemiaController.dispose();
    obsController.dispose();
    dtUltimaMestruacaoController.dispose();
    dtProvavelPartoController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: BlocProvider<MedRecordBloc>(
        create: (context) => this._medRecordBloc,
        child: BlocListener<MedRecordBloc, MedRecordState>(
          listener: (context, state) {},
          child: BlocBuilder<MedRecordBloc, MedRecordState>(
            builder: (context, state) {
              return SafeArea(
                child: Form(
                  key: _preDiagnosisFormKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        textFormField(
                            pesoController,
                            'Peso',
                            'Insira o peso do paciente',
                            'Por Favor, Insira o peso do paciente'),
                        textFormField(
                            alturaController,
                            'Altura',
                            'Insira a altura do paciente em cm',
                            'Por Favor, Insira a altura do paciente'),
//inserir calculo do imc
                        textFormField(
                            pASistolicaController,
                            'P.A.',
                            'Insira o valor da Pressão Artorial do paciente',
                            'Por Favor, Insira um valor para a P.A.'),
                        textFormField(
                            pADiastolicaController,
                            'P.D.',
                            'Insira o valor da Pressão Diastólica do paciente',
                            'Por Favor, Insira um valor para a P.D.'),
                        textFormField(
                            freqCardiacaController,
                            'Freq. Cardíaca',
                            'Insira o valor da Frequência Cardíaca do paciente',
                            'Por Favor, Insira um valor para a F.C.'),
                        textFormField(
                            freqRepousoController,
                            'Freq. Repouso',
                            'Insira o valor da Frequência de Repouso do paciente',
                            'Por Favor, Insira um valor para a Freq. Repouso'),
                        textFormField(
                            temperaturaController,
                            'Temperatura',
                            'Insira o valor da Temperatura do paciente',
                            'Por Favor, Insira a temperatura'),
                        textFormField(
                            glicemiaController,
                            'Glicemia',
                            'Insira o valor da Glicemia do paciente',
                            'Por Favor, Insira o valor da Glicemia'),
                        formFieldFemalePacient(),
                        textFormField(
                            obsController, 'Observações', 'Observações', ''),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MaterialButton(
                            color: Color(0xFF84FFFF),
                            height: 55.0,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                            ),
                            onPressed: () async {
                              if (_preDiagnosisFormKey.currentState.validate())
                                _medRecordBloc
                                    .add(PreDiagnosisCreateButtonPressed(
                                  peso: pesoController.text,
                                  altura: alturaController.text,
                                  imc: imcController.text,
                                  pASistolica: pASistolicaController.text,
                                  pADiastolica: pADiastolicaController.text,
                                  freqCardiaca: freqCardiacaController.text,
                                  freqRepouso: freqRepousoController.text,
                                  temperatura: temperaturaController.text,
                                  glicemia: glicemiaController.text,
                                  obs: obsController.text,
                                  dtUltimaMestruacao:
                                      dtUltimaMestruacaoController.text,
                                  dtProvavelParto:
                                      dtProvavelPartoController.text,
                                ));
                            },
                            child: Text('Cadastrar Pré-Atendimento'),
                          ),
                        ),
                      ]),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget formFieldFemalePacient() {
    if (pacient.getSexo == 'Feminino') {
      return Column(
        children: [
          textFormField(
              dtUltimaMestruacaoController,
              'Data da última mestruação',
              'Insira a data da última mestruação da paciente',
              'Por Favor, Insira a data da última mestruação'),
          textFormField(
              dtProvavelPartoController,
              'Data provavél do parto',
              'Insira a data provavél do parto',
              'Por Favor, Insira a data provavél do parto'),
        ],
      );
    } else
      return Row();
  }

  Widget textFormField(controller, label, hint, errorText) {
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
        validator: (value) {
          if (value.isEmpty) {
            return errorText;
          }
          return null;
        },
      ),
    );
  }
}
