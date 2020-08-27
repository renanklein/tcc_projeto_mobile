import 'package:flutter/cupertino.dart';

class ConfirmDialog {
  final String title;
  final String description;
  final String buttonTitle;

  ConfirmDialog({
    @required this.title,
    @required this.description,
    @required this.buttonTitle,
  });
}

class ReturnDialog {
  final String title;
  final String description;
  final String button1;
  final String button2;

  ReturnDialog({
    @required this.title,
    @required this.description,
    @required this.button1,
    @required this.button2,
  });
}
