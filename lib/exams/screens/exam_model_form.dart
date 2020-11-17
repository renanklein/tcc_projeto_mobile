import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcc_projeto_app/exams/blocs/exam_bloc.dart';
import 'package:tcc_projeto_app/exams/tiles/exam_details_field.dart';
import 'package:tcc_projeto_app/exams/tiles/exam_dynamic_fields.dart';
import 'package:tcc_projeto_app/utils/datetime_form_field.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';
import 'package:tcc_projeto_app/utils/text_form_field.dart';

class ExamModelForm extends StatefulWidget {
  List dynamicFields = [];

  @override
  _ExamModelFormState createState() => _ExamModelFormState();
}

class _ExamModelFormState extends State<ExamModelForm> {
  String examTypePlaceholder = "Tipo de Exame";
  String examDatePlaceholder = "Data de Realização";
  GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  ExamBloc _examBloc;
  TextEditingController _examTypeController = TextEditingController();
  TextEditingController _examDateController = TextEditingController();

  List get dynamicModelFields => this.widget.dynamicFields;

  @override
  void initState() {
    this._examBloc = BlocProvider.of<ExamBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: this._scaffoldKey,
      appBar: AppBar(
        title: Text("Cadastrar modelo de exame"),
        centerTitle: true,
      ),
      body: BlocListener<ExamBloc, ExamState>(
        listener: (context, state) {
          if (state is CreateExamModelSuccess) {
            Navigator.of(context).pop();
          }
        },
        child: BlocBuilder<ExamBloc, ExamState>(
          builder: (context, state) {
            if (state is CreateExamModelProcessing) {
              return LayoutUtils.buildCircularProgressIndicator(context);
            }
            return Builder(
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView(
                    children: [
                      ..._buildMandatoryFields(),
                      ..._buildFieldsRow(),
                      _buildAddFieldButton(),
                      _buildCreateModelButton()
                    ],
                  ),
                );
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
          fieldPlaceholder: this.examTypePlaceholder),
      LayoutUtils.buildVerticalSpacing(10.0),
      DateTimeFormField(
        fieldPlaceholder: this.examDatePlaceholder,
        dateTimeController: this._examDateController,
      ),
      LayoutUtils.buildVerticalSpacing(10.0),
    ];
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

  Widget _buildAddFieldButton() {
    return Builder(
      builder: (context) {
        return RaisedButton(
          onPressed: () {
            Scaffold.of(context).showBottomSheet(
              (context) => ExamDynamicFieldsBottomsheet(
                dynamicFieldsList: this.dynamicModelFields,
                refreshForm: this.refreshFields,
              ),
              backgroundColor: Colors.transparent,
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
          color: Theme.of(context).primaryColor,
          child: Text(
            "Adicione um campo",
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildCreateModelButton() {
    return RaisedButton(
      onPressed: () {
        this._examBloc.add(CreateExamModel(
              examTypeMap: {
                this.examTypePlaceholder: this._examTypeController.text
              },
              examDateMap: {
                this.examDatePlaceholder: this._examDateController.text
              },
              listOfFields: this.dynamicModelFields,
            ));
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32.0),
      ),
      color: Theme.of(context).primaryColor,
      child: Text(
        "Cadastrar modelo",
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