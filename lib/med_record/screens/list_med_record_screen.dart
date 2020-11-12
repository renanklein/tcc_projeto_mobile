import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:flutter/widgets.dart';
import 'package:tcc_projeto_app/exams/repositories/exam_repository.dart';
import 'package:tcc_projeto_app/exams/screens/exam_screen.dart';
import 'package:tcc_projeto_app/login/blocs/authentication_bloc.dart';
import 'package:tcc_projeto_app/med_record/blocs/med_record_bloc.dart';
import 'package:tcc_projeto_app/med_record/models/med_record_model.dart';
import 'package:tcc_projeto_app/med_record/repositories/med_record_repository.dart';
import 'package:tcc_projeto_app/med_record/screens/create_diagnosis_screen.dart';
import 'package:tcc_projeto_app/exams/screens/exam_form_screen.dart';
import 'package:tcc_projeto_app/routes/medRecordArguments.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';
import 'package:tcc_projeto_app/login/repositories/user_repository.dart';
import 'package:tcc_projeto_app/utils/slt_pattern.dart';

class MedRecordScreen extends StatefulWidget {
  final MedRecordArguments medRecordArguments;

  MedRecordScreen({
    @required this.medRecordArguments,
  });

  @override
  _MedRecordScreenState createState() => _MedRecordScreenState();
}

class _MedRecordScreenState extends State<MedRecordScreen> {
  MedRecordBloc _medRecordBloc;
  MedRecordRepository _medRecordRepository;
  MedRecordModel _medRecordModel;
  String pacientHash;
  //UserModel _userModel;

  //TODO: Implementar modelo de prontuario

  MedRecordArguments get medRecordArguments => this.widget.medRecordArguments;

  int _selectedIndex;

  final userRepository = Injector.appInstance.getDependency<UserRepository>();
  @override
  void initState() {
    this.pacientHash = _hasPacientHashArguments()
        ? null
        : SltPattern.retrivepacientHash(this.medRecordArguments.pacientCpf,
            this.medRecordArguments.pacientSalt);
    var injector = Injector.appInstance;
    this._medRecordRepository = injector.getDependency<MedRecordRepository>();
    var examRepository = injector.getDependency<ExamRepository>();
    this._medRecordBloc = new MedRecordBloc(
        medRecordRepository: this._medRecordRepository,
        examRepository: examRepository);

    if (medRecordArguments.index != null) {
      _selectedIndex = _parseIndex(medRecordArguments.index);
    } else {
      _selectedIndex = 1;
    }

    if (medRecordArguments.pacientCpf != null &&
        medRecordArguments.pacientSalt != null) {
      _medRecordBloc.add(
        MedRecordLoad(
          pacientCpf: medRecordArguments.pacientCpf,
          pacientSalt: medRecordArguments.pacientSalt,
        ),
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    //nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Prontuário Médico"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
      ),
      body: BlocProvider<MedRecordBloc>(
        create: (context) => this._medRecordBloc,
        child: BlocListener<MedRecordBloc, MedRecordState>(
          listener: (context, state) {
            if (state is AuthenticationUnauthenticated) {
            } else if (state is MedRecordLoadEventSuccess) {
              _medRecordModel = state.medRecordLoaded;
            }
          },
          child: BlocBuilder<MedRecordBloc, MedRecordState>(
            builder: (context, state) {
              if (state is CreateMedRecordEventProcessing) {
                return LayoutUtils.buildCircularProgressIndicator(context);
              }
              return SafeArea(
                child: Row(
                  children: <Widget>[
                    LayoutBuilder(
                      builder: (context, constraint) {
                        return SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints(minHeight: constraint.maxHeight),
                            child: IntrinsicHeight(
                              child: NavigationRail(
                                selectedIndex: _selectedIndex,
                                onDestinationSelected: (int index) {
                                  setState(() {
                                    _selectedIndex = index;
                                  });
                                },
                                labelType: NavigationRailLabelType.selected,
                                destinations: [
                                  NavigationRailDestination(
                                    icon: Icon(Icons.add_circle),
                                    label: Text('Novo'),
                                  ),
                                  NavigationRailDestination(
                                    icon: Icon(Icons.portrait),
                                    label: Text('Resumo'),
                                  ),
                                  NavigationRailDestination(
                                    icon: Icon(Icons.content_paste),
                                    label: Text('Exames'),
                                  ),
                                  NavigationRailDestination(
                                    icon: Icon(Icons.question_answer),
                                    label: Text('Diagnóstico'),
                                  ),
                                  NavigationRailDestination(
                                    icon: Icon(Icons.healing),
                                    label: Text('Evolução'),
                                  ),
                                  NavigationRailDestination(
                                    icon: Icon(Icons.file_upload),
                                    label: Text('Third'),
                                  ),
                                  NavigationRailDestination(
                                    icon: Icon(Icons.add_to_photos),
                                    label: Text('Third'),
                                  ),
                                  NavigationRailDestination(
                                    icon: Icon(Icons.child_friendly),
                                    label: Text('Ficha RN'),
                                  ),
                                  NavigationRailDestination(
                                    icon: Icon(Icons.apps),
                                    label: Text('Third'),
                                  ),
                                  NavigationRailDestination(
                                    icon: Icon(Icons.close),
                                    label: Text('Third'),
                                  ),
                                  NavigationRailDestination(
                                    icon: Icon(Icons.compare),
                                    //selectedIcon: Icon(Icons.star),
                                    label: Text('Third'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    VerticalDivider(thickness: 1, width: 1),
                    // This is the main content.
                    Expanded(
                      child: Center(
                        child: _showMedRecord(_selectedIndex, context),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _showMedRecord(index, context) {
    switch (index) {
      case 2:
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Flexible(
                  child: ExamScreen(
                pacientHash: this.pacientHash,
              )),
              RaisedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => ExamFormScreen(
                                medRecordArguments: this.medRecordArguments,
                              )))
                      .then((value) => {
                            this
                                ._medRecordBloc
                                .add(GetExams(pacientHash: this.pacientHash))
                          });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
                color: Theme.of(context).primaryColor,
                child: Text(
                  "Clique aqui para inserir um exame",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
        break;

      case 3:
        return CreateDiagnosisScreen();
        break;

      default:
        return Text('selectedIndex: $index');
        break;
    }
  }

  _parseIndex(index) {
    switch (index) {
      case 'examScreen':
        return 2;
        break;
      default:
        return 1;
        break;
    }
  }

  bool _hasPacientHashArguments() {
    return (this.medRecordArguments.pacientCpf.isEmpty &&
        this.medRecordArguments.pacientSalt.isEmpty);
  }
}
