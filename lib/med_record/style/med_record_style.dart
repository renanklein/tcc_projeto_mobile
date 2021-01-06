import 'package:flutter/material.dart';

class MedRecordStyle {
  final EdgeInsets _containerMargin = const EdgeInsets.fromLTRB(
    0.0,
    0.0,
    0.0,
    4.0,
  );
  final EdgeInsets _formTextPadding = const EdgeInsets.fromLTRB(
    0.0,
    5.0,
    0.0,
    0.0,
  );
  final TextStyle _formTextStyle = const TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 17.0,
  );

  Widget breakLine() {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  EdgeInsets get containerMargin => this._containerMargin;
  EdgeInsets get formTextPadding => this._formTextPadding;
  TextStyle get formTextStyle => this._formTextStyle;
}
