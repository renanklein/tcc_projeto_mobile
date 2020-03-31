import 'package:flutter/material.dart';

class EventReason extends StatelessWidget {
  final reasonController;

  EventReason({@required this.reasonController});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: reasonController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 20.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          hintText: "Razão do cancelamento"),
    );
  }
}