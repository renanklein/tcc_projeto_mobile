import 'package:flutter/material.dart';

class ExamDetailsField extends StatefulWidget {
  final fieldValue;
  final fieldPlaceholder;

  ExamDetailsField(
      {@required this.fieldValue, @required this.fieldPlaceholder});

  @override
  _ExamDetailsFieldState createState() => _ExamDetailsFieldState();
}

class _ExamDetailsFieldState extends State<ExamDetailsField> {
  TextEditingController controller = TextEditingController();
  String get fieldValue => this.widget.fieldValue;
  String get fieldPlaceholder => this.widget.fieldPlaceholder;

  @override
  void initState() {
    this.controller.text = this.fieldPlaceholder;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: this.controller,
      readOnly: true,
      minLines: 1,
      maxLines: 5,
      keyboardType: TextInputType.multiline,
      decoration: _buildFieldDecoration(),
      onTap: () {
        setState(() {
          this.controller.text = this.fieldValue;
        });
      },
    );
  }

  InputDecoration _buildFieldDecoration() {
    return InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 20.0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
    );
  }
}
