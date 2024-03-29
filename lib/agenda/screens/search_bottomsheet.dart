import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/utils/datetime_form_field.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';
import 'package:tcc_projeto_app/utils/text_form_field.dart';

class SearchBottomSheet extends StatelessWidget {
  final TextEditingController pacientSearchController = TextEditingController();
  final TextEditingController dateSearchController;
  final Function filterFunction;

  SearchBottomSheet({@required this.filterFunction, @required this.dateSearchController});

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
      child: ListView(
        children: [
          Field(
            textController: this.pacientSearchController,
            fieldPlaceholder: "Nome do paciente",
            isReadOnly: false,
          ),
          LayoutUtils.buildVerticalSpacing(10.0),
          DateTimeFormField(
            dateTimeController: this.dateSearchController,
            fieldPlaceholder: "Data dos agendamentos",
          ),
          LayoutUtils.buildVerticalSpacing(10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Center(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.blue, fontSize: 18.0),
                  text: "Pesquisar",
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      this.filterFunction(this.pacientSearchController.text);

                      Navigator.of(context).pop();
                    },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
