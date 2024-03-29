import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:intl/intl.dart';
import 'package:tcc_projeto_app/exams/models/exam_details.dart';
import 'package:tcc_projeto_app/exams/screens/exam_details_screen.dart';
import 'package:tcc_projeto_app/login/models/user_model.dart';
import 'package:tcc_projeto_app/med_record/blocs/med_record_bloc.dart';
import 'package:tcc_projeto_app/med_record/models/diagnosis/complete_diagnosis_model.dart';
import 'package:tcc_projeto_app/med_record/models/pre_diagnosis/pre_diagnosis_model.dart';
import 'package:tcc_projeto_app/med_record/repositories/med_record_repository.dart';
import 'package:tcc_projeto_app/pacient/models/pacient_model.dart';
import 'package:tcc_projeto_app/utils/dynamic_field_bottomsheet.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';
import 'package:tcc_projeto_app/utils/prescription_sender.dart';
import 'package:tcc_projeto_app/utils/text_form_field.dart';

class DiagnosisTile extends StatefulWidget {
  final DateTime date;
  final List<Widget> fields;
  final bool isPrediagnosis;
  final CompleteDiagnosisModel diagnosisModel;
  final PreDiagnosisModel preDiagnosisModel;
  final Function refresh;
  final PacientModel pacient;

  DiagnosisTile(
      {@required this.date,
      @required this.fields,
      @required this.isPrediagnosis,
      @required this.diagnosisModel,
      @required this.preDiagnosisModel,
      @required this.refresh,
      @required this.pacient});

  static List<DiagnosisTile> fromDiagnosis(
      List<CompleteDiagnosisModel> diagnosisList,
      BuildContext context,
      Function refreshDiagnosis,
      PacientModel pacient) {
    return diagnosisList.map((diagnosis) {
      return DiagnosisTile(
        isPrediagnosis: false,
        refresh: refreshDiagnosis,
        date: diagnosis?.diagnosisDate,
        diagnosisModel: diagnosis,
        pacient: pacient,
        preDiagnosisModel: null,
        fields: [
          ...diagnosis?.toWidgetFields(),
        ],
      );
    }).toList();
  }

  static List<DiagnosisTile> fromPreDiagnosisList(
      List<PreDiagnosisModel> prediagnosisList,
      Function refreshPreDiagnosis,
      PacientModel pacient) {
    return prediagnosisList.map((preDiagnosis) {
      return DiagnosisTile(
          isPrediagnosis: true,
          refresh: refreshPreDiagnosis,
          preDiagnosisModel: preDiagnosis,
          pacient: pacient,
          diagnosisModel: null,
          date: preDiagnosis.getPreDiagnosisDate,
          fields: preDiagnosis.toWidgetFields());
    }).toList();
  }

  @override
  _DiagnosisTileState createState() => _DiagnosisTileState();
}

class _DiagnosisTileState extends State<DiagnosisTile> {
  DateTime get date => this.widget.date;
  List<Widget> get fields => this.widget.fields;
  PreDiagnosisModel get preDiagnosis => this.widget.preDiagnosisModel;
  CompleteDiagnosisModel get completeDiagnosisModel =>
      this.widget.diagnosisModel;
  bool get isPrediagnosis => this.widget.isPrediagnosis;
  PacientModel get pacient => this.widget.pacient;
  List<Widget> children = <Widget>[];
  Function get refresh => this.refresh;
  MedRecordBloc medRecordBloc;
  String dateAsString;

  @override
  void initState() {
    var medRepository = Injector.appInstance.get<MedRecordRepository>();
    this.medRecordBloc = MedRecordBloc(medRecordRepository: medRepository);
    if (!this.isPrediagnosis) {
      this.medRecordBloc.add(GetExamByDiagnosisDateAndId(
          diagnosisDate: this.completeDiagnosisModel.diagnosisDate,
          diagnosisId: this.completeDiagnosisModel.id));
    }
    var formatter = DateFormat('dd/MM/yyyy');
    this.dateAsString = formatter.format(this.date);
    this.children = [
      ...fields,
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Scaffold.of(context).showBottomSheet((context) =>
                    DynamicFieldBottomSheet(
                        popBottomsheet: true,
                        dynamicFieldsList: this.children,
                        refreshForm: refreshTile,
                        saveDynamicField: updateDiagnosisOrPrediagnosis));
              }),
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                this._changeToEditMode(updateDiagnosisOrPrediagnosis);
              }),
        ],
      ),
      LayoutUtils.buildVerticalSpacing(3.0),
      this.isPrediagnosis
          ? Container()
          : _buildButton("Enviar prescrição por email", () async {
              await this._processPrescriptionEmail();
            }),
      LayoutUtils.buildVerticalSpacing(5.0),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MedRecordBloc, MedRecordState>(
        bloc: this.medRecordBloc,
        listener: (context, state) {
          if (state is DiagnosisCreateOrUpdateSuccess) {
            setState(() {
              this.children = <Widget>[
                ...state.diagnosisModel.toWidgetFields(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          Scaffold.of(context).showBottomSheet((context) =>
                              DynamicFieldBottomSheet(
                                  popBottomsheet: true,
                                  dynamicFieldsList:
                                      state.diagnosisModel.dynamicFields,
                                  refreshForm: this.refresh,
                                  saveDynamicField: updateDiagnosisOrPrediagnosis,));
                        }),
                    IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          this._changeToEditMode(updateDiagnosisOrPrediagnosis);
                        })
                  ],
                ),
                LayoutUtils.buildVerticalSpacing(3.0),
                _buildButton("Enviar prescrição por email", () async {
                  await this._processPrescriptionEmail();
                }),
                LayoutUtils.buildVerticalSpacing(5.0)
              ];
            });
          } else if (state is PreDiagnosisCreateOrUpdateSuccess) {
            setState(() {
              this.children = <Widget>[
                ...state.preDiagnosisModel.toWidgetFields(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          Scaffold.of(context).showBottomSheet((context) =>
                              DynamicFieldBottomSheet(
                                  popBottomsheet: true,
                                  dynamicFieldsList:
                                      state.preDiagnosisModel.dynamicFields,
                                  refreshForm: this.refresh, 
                                  saveDynamicField: updateDiagnosisOrPrediagnosis));
                        }),
                    IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          this._changeToEditMode(updateDiagnosisOrPrediagnosis);
                        })
                  ],
                )
              ];
            });
          } else if (state is GetExamByDiagnosisDateAndIdSuccess) {
            setState(() {
              if (state.exam != null) {
                this.children.add(LayoutUtils.buildVerticalSpacing(3.0));
                var examDetails =
                    ExamDetails.fromMap(state.exam["dynamicFields"]);

                this.children.add(_buildButton("Acessar o exame", () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ExamDetailsScreen(
                              examDetails: examDetails,
                              fileDownloadURL: state.exam["fileDownloadURL"],
                              iv: state.exam["IV"],
                              examDate: state.exam["examDate"],
                              examType: state.exam["examType"])));
                    }));
              }
            });
          }
        },
        child: BlocBuilder<MedRecordBloc, MedRecordState>(
          bloc: this.medRecordBloc,
          builder: (context, state) {
            if (state is MedRecordEventProcessing || state is GetExamByDiagnosisDateAndIdProcessing) {
              return LayoutUtils.buildCircularProgressIndicator(context);
            }

            return ExpansionTile(
                childrenPadding: EdgeInsets.only(left: 17.0),
                title: Text(dateAsString,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 17.0)),
                expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                children: this.children);
          },
        ));
  }

  void _changeToEditMode(Function onTap) {
    var newFields = <Widget>[];

    this.children.forEach((field) {
      if (field is Text) {
        var dataSplited = field.data.split(':');
        newFields.add(Field(
            fieldPlaceholder: dataSplited[0],
            textController: TextEditingController(text: dataSplited[1]),
            isReadOnly: false));
        newFields.add(LayoutUtils.buildVerticalSpacing(5.0));
      }
    });

    newFields.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        this._buildButton("Voltar", this._changeToReadOnlyMode),
        this._buildButton("Salvar", onTap),
      ],
    ));

    setState(() {
      this.children = newFields;
    });
  }

  void _changeToReadOnlyMode() {
    var newFields = <Widget>[];

    this.children.forEach((field) {
      if (field is Field) {
        newFields.add(
            Text("${field.fieldPlaceholder}: ${field.textController.text}"));
      }
    });
    newFields.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Scaffold.of(context).showBottomSheet((context) =>
                    DynamicFieldBottomSheet(
                        popBottomsheet: true,
                        dynamicFieldsList: this.children,
                        refreshForm: refreshTile,
                        saveDynamicField: updateDiagnosisOrPrediagnosis,));
              }),
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                this._changeToEditMode(updateDiagnosisOrPrediagnosis);
              })
        ],
      ),
    );
    setState(() {
      this.children = newFields;
    });
  }

  Widget _buildButton(String text, Function onPressBehaviour) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Center(
        child: RichText(
          text: TextSpan(
              style: TextStyle(color: Colors.blue, fontSize: 16.0),
              text: text,
              recognizer: TapGestureRecognizer()..onTap = onPressBehaviour),
        ),
      ),
    );
  }

  void updateDiagnosisOrPrediagnosis() {
    if (this.isPrediagnosis) {
      this.medRecordBloc.add(PreDiagnosisCreateOrUpdateButtonPressed.fromModel(
          PreDiagnosisModel.fromWidgetFields(this.children, this.dateAsString),
          true));
    } else {
      var newDiagnosis = CompleteDiagnosisModel.fromWidgetFields(
          this.children, this.dateAsString);
      newDiagnosis.setId = this.completeDiagnosisModel.id;
      this.medRecordBloc.add(
          DiagnosisCreateOrUpdateButtonPressed.fromModel(true, newDiagnosis));
    }
  }

  Future _processPrescriptionEmail() async {
    var diagnosis = CompleteDiagnosisModel.fromWidgetFields(
        this.children, this.dateAsString);
    var prescriptionPdf =
        await PrescriptionSender.prescriptionToPdf(diagnosis, this.pacient);
    var user = Injector.appInstance.get<UserModel>();
    var recipients = [user.email, this.pacient.getEmail];
    var body = "Segue me anexo a prescrição do diagnóstico";
    await PrescriptionSender.sendEmail(recipients, body, prescriptionPdf,
        "Prescrição ${pacient.getNome} ${this.dateAsString}", context);
  }

  void refreshTile(List dynamicList, Field newField) {
    var text = Text(
        "${newField.fieldPlaceholder}: ${newField.textController.text}",
        style: TextStyle(fontSize: 14.0));
    setState(() {
      var index = 0;
      for (int i = 0; i < dynamicList.length; i++) {
        if (dynamicList[i] is Row) {
          index = i;
        }
      }

      dynamicList.insert(index, text);
    });
  }
}
