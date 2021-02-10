import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExamDetailsField extends StatefulWidget {
  final fieldValue;
  final fieldPlaceholder;
  final controller = TextEditingController();
  final isReadOnly;

  ExamDetailsField(
      {@required this.fieldValue,
      @required this.fieldPlaceholder,
      @required this.isReadOnly});

  @override
  _ExamDetailsFieldState createState() => _ExamDetailsFieldState();
}

class _ExamDetailsFieldState extends State<ExamDetailsField> {
  bool get isReadOnly => this.widget.isReadOnly;
  String get fieldValue => this.widget.fieldValue;
  String get fieldPlaceholder => this.widget.fieldPlaceholder;
  TextEditingController get controller => this.widget.controller;
  bool isPlaceholder;

  @override
  void initState() {
    if (this.isReadOnly) {
      this.controller.text = this.controller.text = this.fieldPlaceholder;
      this.isPlaceholder = true;
    } else {
      this.controller.text = this.fieldValue;
      this.isPlaceholder = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: this.controller,
      validator: (value) {
        if (value.isEmpty) {
          return "O campo não foi preenchido";
        }

        return null;
      },
      textInputAction: TextInputAction.next,
      readOnly: this.isReadOnly,
      keyboardType: TextInputType.multiline,
      decoration: _buildFieldDecoration(),
      onEditingComplete: () {
        // Escaping the "remove" field button focus from the row in list of fields
        for (int i = 0; i < 2; i++) {
          FocusScope.of(context).nextFocus();
        }
      },
      onTap: () {
        if (this.isReadOnly) {
          setState(() {
            if (isPlaceholder) {
              this.controller.text = this.fieldValue;
              this.isPlaceholder = false;
            } else {
              this.controller.text =
                  this.controller.text = this.fieldPlaceholder;
              this.isPlaceholder = true;
            }
          });
        }
      },
    );
  }

  InputDecoration _buildFieldDecoration() {
    return InputDecoration(
      hintText: this.fieldPlaceholder,
      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 20.0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
    );
  }
}
