import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:injector/injector.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcc_projeto_app/exams/models/card_exam_info.dart';
import 'package:tcc_projeto_app/exams/models/exam_details.dart';
import 'package:tcc_projeto_app/exams/repositories/exam_repository.dart';
import 'package:tcc_projeto_app/med_record/blocs/med_record_bloc.dart';
import 'package:tcc_projeto_app/med_record/repositories/med_record_repository.dart';
import 'package:tcc_projeto_app/med_record/screens/list_med_record_screen.dart';
import 'package:tcc_projeto_app/routes/medRecordArguments.dart';
import 'package:tcc_projeto_app/utils/datetime_form_field.dart';
import 'package:tcc_projeto_app/utils/dynamic_field_bottomsheet.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';
import 'package:tcc_projeto_app/utils/text_form_field.dart';

class ExamFormScreen extends StatefulWidget {
  List dynamicFieldsList = <Widget>[];
  final medRecordArguments;
  final DateTime diagnosisDate;
  final int diagnosisId;
  final String screenContext;
  final String examType;
  final String examSolicitationId;
  final DateTime solicitationDate;

  ExamFormScreen(
      {@required this.medRecordArguments,
      this.diagnosisDate,
      this.diagnosisId,
      this.screenContext,
      @required this.examType,
      @required this.examSolicitationId,
      this.solicitationDate});
  @override
  _ExamFormScreenState createState() => _ExamFormScreenState();
}

class _ExamFormScreenState extends State<ExamFormScreen> {
  MedRecordBloc _medRecordBloc;
  TextEditingController _examTypeController = TextEditingController();
  TextEditingController _examDateController = TextEditingController();
  String currentDropdownItem;
  Map<String, Map> modelExams = Map<String, Map>();
  List<Widget> examModelsFields = <Widget>[];
  List<String> examModelsTypes = <String>[];
  File _examFile;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  List<Widget> get dynamicFieldsList => this.widget.dynamicFieldsList;
  MedRecordArguments get medRecordArguments => this.widget.medRecordArguments;
  DateTime get diagnosisDate => this.widget.diagnosisDate;
  int get diagnosisId => this.widget.diagnosisId;
  String get screenContext => this.widget.screenContext;
  String get examType => this.widget.examType;
  String get examSolicitationId => this.widget.examSolicitationId;
  DateTime get solicitationDate => this.widget.solicitationDate;

  @override
  void initState() {
    this._medRecordBloc = MedRecordBloc(
        medRecordRepository: Injector.appInstance.get<MedRecordRepository>(),
        examRepository: Injector.appInstance.get<ExamRepository>());

    this._medRecordBloc.add(LoadExamModels());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: this._scaffoldKey,
        appBar: AppBar(
          title: Text("Salvar exame"),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: BlocListener<MedRecordBloc, MedRecordState>(
          bloc: this._medRecordBloc,
          listener: (context, state) {
            if (state is ExamProcessingSuccess) {
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MedRecordScreen(
                      medRecordArguments: MedRecordArguments(
                        pacientModel: this.medRecordArguments.pacientModel,
                        index: "2"
                      ))));
            } else if (state is DynamicExamFieldSuccess) {
              setState(() {
                this.dynamicFieldsList.add(state.dynamicFieldWidget);
              });
            } else if (state is ExamProcessingFail) {
              onFail("Ocorreu um erro ao tentar salvar o exame");
            } else if (state is LoadExamModelSuccess) {
              var firstType = "";
              state.models["models"].forEach((map) {
                if(map["Tipo de Exame"].toLowerCase() == this.examType.toLowerCase()){
                  firstType = map["Tipo de Exame"];
                }
                this.examModelsTypes.add(map["Tipo de Exame"]);
                this.modelExams.addAll({map["Tipo de Exame"]: map["fields"]});
              });
              if (this.examType != null && this.examType.isNotEmpty) {
                this._examTypeController.text = firstType;
                this.currentDropdownItem = firstType;
              } else {
                this._examTypeController.text = this.examModelsTypes.first;
                this.currentDropdownItem = this.examModelsTypes.first;
              }
            }
          },
          child: BlocBuilder<MedRecordBloc, MedRecordState>(
              bloc: this._medRecordBloc,
              builder: (context, state) {
                if (state is ExamProcessing) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(child: _buildFormBody()),
                );
              }),
        ));
  }

  Widget _buildFormBody() {
    return Form(
      key: this._formKey,
      child: ListView(
        children: [
          Field(
            textController: this._examTypeController,
            fieldPlaceholder: "Tipo de Exame",
            isReadOnly: false,
          ),
          LayoutUtils.buildVerticalSpacing(10.0),
          DateTimeFormField(
            solicitationDate: this.solicitationDate ?? DateTime.now(),
            fieldPlaceholder: "Data de Realização",
            dateTimeController: this._examDateController,
          ),
          LayoutUtils.buildVerticalSpacing(10.0),
          ..._buildModelTypeDropDownButton(),
          ..._buildModelExamFields(this.modelExams[this.currentDropdownItem]),
          ..._buildFieldsRow(),
          ElevatedButton(
            onPressed: () {
              this._scaffoldKey.currentState.showBottomSheet(
                    (context) => DynamicFieldBottomSheet(
                      popBottomsheet: true,
                      dynamicFieldsList: this.dynamicFieldsList,
                      refreshForm: this.refreshFields,
                    ),
                    backgroundColor: Colors.transparent,
                  );
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
              primary: Theme.of(context).primaryColor,
            ),
            child: Text(
              "Adicione um campo",
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              _setExamFile();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
              primary: Theme.of(context).primaryColor,
            ),
            child: Text(
              "Escolha imagem",
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          LayoutUtils.buildVerticalSpacing(10.0),
          _createSubmitButton()
        ],
      ),
    );
  }

  List<Widget> _buildModelTypeDropDownButton() {
    var dropdownWidgets = <Widget>[];
    if (this.examModelsTypes.isEmpty) {
      return dropdownWidgets;
    }
    dropdownWidgets
        .add(Center(child: Text("Selecione o modelo de exame abaixo")));

    dropdownWidgets.add(LayoutUtils.buildVerticalSpacing(5.0));

    dropdownWidgets.add(Container(
      alignment: Alignment.center,
      child: DropdownButton<String>(
        items: this.examModelsTypes.map((el) {
          return DropdownMenuItem(value: el, child: Text(el));
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            this._examTypeController.text = newValue;
            this.currentDropdownItem = newValue;
          });
        },
        value: this.currentDropdownItem,
      ),
    ));

    return dropdownWidgets;
  }

  List<Widget> _buildModelExamFields(Map fields) {
    var dropDownFields = <Widget>[];
    this.examModelsFields = <Widget>[];
    if (fields != null) {
      fields.forEach((fieldType, defaultValue) {
        var examDetailsField = Field(
            fieldPlaceholder: fieldType,
            textController: TextEditingController(
              text: defaultValue
            ),
            isReadOnly: false);
        this.examModelsFields.add(examDetailsField);
        var row = Row(
          children: [
            Expanded(child: examDetailsField),
            IconButton(
                icon: Icon(Icons.cancel_outlined,
                    color: Theme.of(context).primaryColor),
                onPressed: () {
                  setState(() {
                    fields.remove(fieldType);
                  });
                })
          ],
        );
        dropDownFields.add(row);
        dropDownFields.add(LayoutUtils.buildVerticalSpacing(10.0));
      });
    }

    return dropDownFields;
  }

  List<Widget> _buildFieldsRow() {
    var examDetailFields = <Widget>[];
    if (this.dynamicFieldsList != null) {
      this.dynamicFieldsList.forEach((el) {
        if (el is Field) {
          var row = IntrinsicHeight(
            child: Row(
              children: [
                Expanded(child: el),
                IconButton(
                    icon: Icon(Icons.cancel_outlined,
                        color: Theme.of(context).primaryColor),
                    onPressed: () {
                      setState(() {
                        this.dynamicFieldsList.remove(el);
                      });
                    })
              ],
            ),
          );
          examDetailFields.add(row);
        } else {
          examDetailFields.add(el);
        }
      });
    }
    return examDetailFields;
  }

  void onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      content: Text(
        "Exame salvo com sucesso",
        style: TextStyle(
            fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.white),
      ),
    ));
  }

  void onFail(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        message,
        style: TextStyle(
            fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.white),
      ),
    ));
  }

  void _setExamFile() async {
    bool isPermissionGranted = await Permission.storage.request().isGranted;

    if (isPermissionGranted) {
      this._examFile = await FilePicker.getFile();
    }
  }

  Widget _createSubmitButton() {
    return SizedBox(
      height: 44.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
          primary: Theme.of(context).primaryColor,
        ),
        child: Text("Salvar",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16.0)),
        onPressed: () {
          if (this._formKey.currentState.validate()) {
            this.dynamicFieldsList.addAll(this.examModelsFields);

            var cardExamInfo = CardExamInfo(
                examDate: this._examDateController.text,
                examType: this._examTypeController.text);

            var examDetails =
                ExamDetails(fieldsWidgetList: this.dynamicFieldsList);

            this._medRecordBloc.add(SaveExam(
                examSolicitationId: this.examSolicitationId,
                medRecordArguments: this.medRecordArguments,
                examDetails: examDetails,
                examFile: _examFile,
                cardExamInfo: cardExamInfo,
                diagnosisDate: this.diagnosisDate,
                diagnosisId: this.diagnosisId));
          }
        },
      ),
    );
  }

  void refreshFields(List fieldsList, Widget newField) {
    setState(() {
      fieldsList.add(newField);
      fieldsList.add(LayoutUtils.buildVerticalSpacing(10.0));
    });
  }

  void refreshFieldsModel(List fieldsList) {
    setState(() {
      this.widget.dynamicFieldsList = fieldsList;
    });
  }
}
