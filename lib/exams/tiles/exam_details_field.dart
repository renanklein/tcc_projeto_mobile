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
  bool isPlaceholder;

  @override
  void initState() {
    this.controller.text = this.fieldPlaceholder;
    this.isPlaceholder = true;
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
          if (isPlaceholder) {
            this.controller.text = this.fieldValue;
            this.isPlaceholder = false;
          } else {
            this.controller.text = this.controller.text = this.fieldPlaceholder;
            this.isPlaceholder = true;
          }
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
