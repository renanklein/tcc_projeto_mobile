import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/med_record/blocs/med_record_bloc.dart';
import 'package:tcc_projeto_app/med_record/repositories/med_record_repository.dart';

class DiagnosisScreen extends StatefulWidget {
  @override
  _DiagnosisScreenState createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  MedRecordBloc _medRecordBloc;
  MedRecordRepository _medRecordRepository;

  final diagnosisFormKey = new GlobalKey<FormState>();

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

//TODO: verificar controller de data
  final problemDateController = TextEditingController();
  final diagnosisDateController = TextEditingController();
  final prescriptionDateController = TextEditingController();

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
    problemDateController.dispose();
    diagnosisDateController.dispose();
    prescriptionDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Diagnóstico"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
      ),
      body: BlocProvider<MedRecordBloc>(
        create: (context) => this._medRecordBloc,
        child: BlocListener<MedRecordBloc, MedRecordState>(
          listener: (context, state) {},
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
                        padding: const EdgeInsets.all(15.0),
                        child: ListView(
                          children: <Widget>[
                            _diagnosisFormField(
                              problemDescriptionController,
                              'Descrição:',
                              'Descreva o problema relatado pelo paciente',
                              'Por Favor, descreva o problema',
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MaterialButton(
                                color: Color(0xFF84FFFF),
                                height: 55.0,
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(15.0),
                                ),
                                onPressed: () async {
                                  if (_diagnosisScreenKey.currentState
                                      .validate()) {
                                    _medRecordBloc.add(
                                      DiagnosisCreateButtonPressed(
                                          //nome: nomeController.text,
                                          ),
                                    );
                                  }
                                },
                                child: Text('Cadastrar Diagnóstico'),
                              ),
                            ),
                          ],
                        ),
                      ),
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
      validator: (value) {
        if (value.isEmpty) {
          return errorText;
        }
        return null;
      },
    ),
  );
}

bool validateData(String value) {
  if (value.length > 10) {
    return false;
  } else if (int.parse(value.substring(0, 2)) < 1 ||
      int.parse(value.substring(0, 2)) > 31) {
    return false;
  } else if (int.parse(value.substring(2, 4)) < 1 ||
      int.parse(value.substring(2, 4)) > 12) {
    return false;
  } else if (int.parse(value.substring(4, 8)) < 1900 ||
      int.parse(value.substring(2, 4)) > DateTime.now().year) {
    return false;
  } else {
    return true;
  }
}
