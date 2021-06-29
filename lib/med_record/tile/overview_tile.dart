import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/med_record/blocs/med_record_bloc.dart';
import 'package:tcc_projeto_app/med_record/repositories/med_record_repository.dart';
import 'package:tcc_projeto_app/med_record/style/med_record_style.dart';
import 'package:tcc_projeto_app/utils/dialog_utils/dialog_widgets.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

class OverviewTile extends StatefulWidget {
  final String pacientCpf;
  final String pacientSalt;

  OverviewTile({
    @required this.pacientCpf,
    @required this.pacientSalt,
  });

  @override
  _OverviewTileState createState() => _OverviewTileState();
}

class _OverviewTileState extends State<OverviewTile> {
  MedRecordBloc _medRecordBloc;
  String initialOverview = '';
  String changedOverview = '';

  bool showForm = false;

  final _overviewFormKey = new GlobalKey<FormState>();
  var _overviewController = TextEditingController();

  String get _pacientCpf => this.widget.pacientCpf;
  String get _pacientSalt => this.widget.pacientSalt;

  @override
  void initState() {
    var _medRepository = Injector.appInstance.get<MedRecordRepository>();
    this._medRecordBloc = MedRecordBloc(medRecordRepository: _medRepository);

    if (_pacientCpf != null && _pacientSalt != null) {
      _medRecordBloc.add(
        MedRecordLoad(
          pacientCpf: _pacientCpf,
          pacientSalt: _pacientSalt,
        ),
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MedRecordBloc, MedRecordState>(
      bloc: _medRecordBloc,
      listener: (context, state) {
        if (state is OverviewCreateOrUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            messageSnackBar(
              context,
              "Resumo atualizado com sucesso.",
              Colors.green,
              Colors.white,
            ),
          );
          changedOverview = state.changedOverview;
          _overviewController.text = changedOverview;

          setState(() {
            showForm = false;
          });
        } else if (state is MedRecordLoadEventSuccess) {
          if (state.medRecordLoaded?.medRecordOverview != null) {
            initialOverview = state.medRecordLoaded.medRecordOverview;
            _overviewController.text = initialOverview;
          }
        }
      },
      child: BlocBuilder<MedRecordBloc, MedRecordState>(
        bloc: _medRecordBloc,
        builder: (context, state) {
          if (state is MedRecordEventProcessing) {
            return LayoutUtils.buildCircularProgressIndicator(context);
          } else {
            return SafeArea(
              child: Form(
                key: _overviewFormKey,
                child: Center(
                  child: (showForm == false)
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.lightBlue[100],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Resumo do Paciente',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blueAccent),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Text((changedOverview != '')
                                    ? changedOverview
                                    : initialOverview),
                              ),
                            ),
                            GestureDetector(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 0.0, 0.0, 6.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Editar Resumo  ',
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                      Icon(Icons.edit),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    showForm = true;
                                  });
                                }),
                            MedRecordStyle().breakLine(),
                          ],
                        )
                      : Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                keyboardType: TextInputType.multiline,
                                controller: _overviewController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  labelText: 'Resumo do Paciente',
                                  hintText: 'Descreva a situação do paciente',
                                ),
                                minLines: 1,
                                maxLines: 15,
                                validator: (value) {
                                  return null;
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: MaterialButton(
                                    color: Color(0xFFE57373),
                                    height: 35.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        showForm = false;
                                      });
                                    },
                                    child: Text(
                                      'Cancelar',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: MaterialButton(
                                    color: Color(0xFF84FFFF),
                                    height: 35.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    onPressed: () async {
                                      if (_overviewFormKey.currentState
                                          .validate()) {
                                        _medRecordBloc.add(
                                          OverviewCreateOrUpdateButtonPressed(
                                            pacientCpf: _pacientCpf,
                                            pacientSalt: _pacientSalt,
                                            resumo: _overviewController.text,
                                          ),
                                        );
                                      }
                                    },
                                    child: Text(
                                      'Atualizar Resumo',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            MedRecordStyle().breakLine(),
                          ],
                        ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
