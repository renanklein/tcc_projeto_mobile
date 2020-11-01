import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcc_projeto_app/med_record/blocs/med_record_bloc.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';
import 'package:tcc_projeto_app/utils/text_form_field.dart';

class ExamDynamicFieldsBottomsheet extends StatefulWidget {
  final fieldNameController = TextEditingController();
  final fieldValueController = TextEditingController();

  @override
  _ExamDinamicFieldsBottomsheetState createState() =>
      _ExamDinamicFieldsBottomsheetState();
}

class _ExamDinamicFieldsBottomsheetState
    extends State<ExamDynamicFieldsBottomsheet> {
  MedRecordBloc medRecordBloc;

  TextEditingController get fieldNameController =>
      this.widget.fieldNameController;
  TextEditingController get fieldValueController =>
      this.widget.fieldValueController;

  @override
  void initState() {
    this.medRecordBloc = BlocProvider.of<MedRecordBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 5, left: 15.0, right: 15.0, bottom: 20.0),
        padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
        height: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: BlocProvider(
          create: (context) => this.medRecordBloc,
          child: BlocListener<MedRecordBloc, MedRecordState>(
            listener: (context, state) {},
            child: BlocBuilder<MedRecordBloc, MedRecordState>(
              cubit: this.medRecordBloc,
              builder: (context, state) {
                if (state is DynamicExamFieldProcessing) {
                  return LayoutUtils.buildCircularProgressIndicator(context);
                }
                return Form(
                    child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Field(
                        textController: fieldNameController,
                        fieldPlaceholder: "Nome do campo",
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Field(
                        textController: fieldValueController,
                        fieldPlaceholder: "Valor do campo",
                      ),
                    ),
                    LayoutUtils.buildVerticalSpacing(10.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: RaisedButton(
                        onPressed: () {
                          this.medRecordBloc.add(DinamicExamField(
                              fieldName: this.fieldNameController.text,
                              fieldValue: this.fieldValueController.text));
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          "Criar campo",
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ));
              },
            ),
          ),
        ));
  }
}
