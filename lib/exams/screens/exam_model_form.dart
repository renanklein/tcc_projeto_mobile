import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcc_projeto_app/exams/blocs/exam_bloc.dart';
import 'package:tcc_projeto_app/exams/screens/exam_form_screen.dart';
import 'package:tcc_projeto_app/exams/tiles/exam_details_field.dart';
import 'package:tcc_projeto_app/routes/medRecordArguments.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';
import 'package:tcc_projeto_app/utils/text_form_field.dart';

class ExamModelForm extends StatefulWidget {
  List dynamicFields = [];
  final bool isEdit;
  final bool fromExamSolicitation;
  final MedRecordArguments medRecordArguments;
  final refreshExamModels;
  String examModelType;
  String examSolicitationId;
  DateTime examSolicitationDate;
  List examModelFields;

  ExamModelForm(
      {@required this.isEdit,
      @required this.fromExamSolicitation,
      this.medRecordArguments,
      this.examModelType,
      this.examModelFields,
      this.examSolicitationId,
      this.examSolicitationDate,
      @required this.refreshExamModels});

  @override
  _ExamModelFormState createState() => _ExamModelFormState();
}

class _ExamModelFormState extends State<ExamModelForm> {
  bool get fromExamSolicitation => this.widget.fromExamSolicitation;
  bool get isEdit => this.widget.isEdit;
  MedRecordArguments get medRecordArguments => this.widget.medRecordArguments;
  String get examModelType => this.widget.examModelType;
  String get examSolicitationId => this.widget.examSolicitationId;
  DateTime get examSolicitationDate => this.widget.examSolicitationDate;
  List get examModelFields => this.widget.examModelFields;
  Function get refreshExamModels => this.widget.refreshExamModels;

  String examTypePlaceholder = "Tipo de Exame";
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  ExamBloc _examBloc;
  String oldExamModelType;
  dynamic examModels;
  TextEditingController _examTypeController = TextEditingController();
  TextEditingController _examModelFieldsNamesController =
      TextEditingController();

  List get dynamicModelFields => this.widget.dynamicFields;

  @override
  void initState() {
    this._examBloc = BlocProvider.of<ExamBloc>(context);
    if (this.isEdit) {
      this._examTypeController.text = this.examModelType;
      this.oldExamModelType = this.examModelType;
      this.examModelFields.forEach((field) {
        this._examModelFieldsNamesController.text += "$field;";
      });
    } else if (this.fromExamSolicitation) {
      this._examTypeController.text = this.examModelType;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: this._scaffoldKey,
      appBar: AppBar(
        title: Text(this.isEdit
            ? "Editar modelo de exame"
            : "Cadastrar modelo de exame"),
        centerTitle: true,
      ),
      body: BlocListener<ExamBloc, ExamState>(
        listener: (context, state) {
          if (state is CreateExamModelSuccess ||
              state is UpdateExamModelSuccess) {
            if (this.fromExamSolicitation) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ExamFormScreen(
                      solicitationDate: this.examSolicitationDate,
                      medRecordArguments: this.medRecordArguments,
                      examType: this._examTypeController.text,
                      examSolicitationId: this.examSolicitationId)));
            } else {
              Future.delayed(Duration(seconds: 2));
              onSuccess();
              Navigator.of(context).pop();
              this.refreshExamModels();
            }
          } else if (state is CreateExamModelFail ||
              state is UpdateExamModelFail) {
            onFail(state);
          }
        },
        child: BlocBuilder<ExamBloc, ExamState>(
          builder: (context, state) {
            if (state is CreateExamModelProcessing ||
                state is UpdateExamModelProcessing) {
              return LayoutUtils.buildCircularProgressIndicator(context);
            }
            return Builder(
              builder: (context) {
                return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Form(
                      key: this._formKey,
                      child: ListView(
                        children: [
                          ..._buildMandatoryFields(),
                          ..._buildFieldsRow(),
                          _buildCreateModelButton()
                        ],
                      ),
                    ));
              },
            );
          },
        ),
      ),
    );
  }

  List _buildMandatoryFields() {
    return <Widget>[
      Field(
        textController: this._examTypeController,
        fieldPlaceholder: this.examTypePlaceholder,
        isReadOnly: false,
      ),
      LayoutUtils.buildVerticalSpacing(10.0),
      TextFormField(
        controller: this._examModelFieldsNamesController,
        readOnly: false,
        validator: (value) {
          if (value.isEmpty) {
            return "Nenhum campo foi informado";
          }

          return null;
        },
        minLines: 3,
        maxLines: 8,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          hintText: "Insira os nomes do campos separados por ;",
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 20.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
      )
    ];
  }

  List<String> _buildListOfFields() {
    var fields = this._examModelFieldsNamesController.text.split(";");

    fields.removeWhere((element) => element == "");
    return fields;
  }

  void onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(this.isEdit
          ? "Modelo editado com sucesso"
          : "Modelo criado com sucesso"),
      backgroundColor: Colors.green,
    ));
  }

  void onFail(ExamState state) {
    var errorMessage = "";
    if (state is CreateExamModelFail) {
      errorMessage = state.errorMessage;
    } else if (state is UpdateExamModelFail) {
      errorMessage = state.errorMessage;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(errorMessage),
      backgroundColor: Colors.red,
    ));
  }

  List _buildFieldsRow() {
    var examDetailFields = <Widget>[];
    if (this.dynamicModelFields != null) {
      this.dynamicModelFields.forEach((el) {
        if (el is ExamDetailsField) {
          var row = IntrinsicHeight(
            child: Row(
              children: [
                Expanded(child: el),
                IconButton(
                    icon: Icon(Icons.cancel_outlined,
                        color: Theme.of(context).primaryColor),
                    onPressed: () {
                      setState(() {
                        this.dynamicModelFields.remove(el);
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

  Widget _buildCreateModelButton() {
    return ElevatedButton(
      onPressed: () {
        if (this._formKey.currentState.validate()) {
          if (this.isEdit) {
            this._examBloc.add(UpdateExamModel(
                fields: _buildListOfFields(),
                oldExamModelType: this.oldExamModelType,
                examModelType: this._examTypeController.text));
          } else {
            this._examBloc.add(CreateExamModel(examTypeMap: {
                  this.examTypePlaceholder: this._examTypeController.text
                }, listOfFields: _buildListOfFields()));
          }
        }
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        primary: Theme.of(context).primaryColor,
      ),
      child: Text(
        this.isEdit ? "Editar modelo" : "Cadastrar modelo",
        style: TextStyle(
            fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  void refreshFields(List fieldsList, Widget newField) {
    Navigator.of(context).pop();
    setState(() {
      fieldsList.add(newField);
      fieldsList.add(LayoutUtils.buildVerticalSpacing(10.0));
    });
  }

  void refreshFieldsModel(List fieldsList) {
    Navigator.of(context).pop();
    setState(() {
      this.widget.dynamicFields = fieldsList;
    });
  }
}
