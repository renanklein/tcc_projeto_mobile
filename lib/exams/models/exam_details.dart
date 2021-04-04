import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/exams/tiles/exam_details_field.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';
import 'package:tcc_projeto_app/utils/readonly_text_field.dart';

class ExamDetails {
  final fieldsWidgetList;

  ExamDetails({@required this.fieldsWidgetList});

  List get getFieldsWidgetList => this.fieldsWidgetList;

  Map toMap() {
    Map fieldValues = Map();
    this.getFieldsWidgetList.forEach((field) {
      if (field is ExamDetailsField) {
        fieldValues.addAll({field.fieldPlaceholder: field.controller.text});
      }
    });

    return fieldValues;
  }

  static ExamDetails fromMap(Map dynamicFieldsMap) {
    var fieldsList = <Widget>[];
    dynamicFieldsMap.forEach((key, value) {
      fieldsList.add(ReadonlyTextField(
        placeholder: key,
        value: value,
      ));
      fieldsList.add(LayoutUtils.buildVerticalSpacing(10.0));
    });

    return ExamDetails(fieldsWidgetList: fieldsList);
  }
}
