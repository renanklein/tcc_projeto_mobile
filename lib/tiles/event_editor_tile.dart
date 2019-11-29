import 'package:flutter/material.dart';

class EventEditorTile extends StatelessWidget {
  final formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Form(
        child: ListView(
          
        ),
      ),
    );
  }
}