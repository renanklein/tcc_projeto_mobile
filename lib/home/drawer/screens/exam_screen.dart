import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/home/drawer/screens/exam_form_screen.dart';

class ExamScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Exames",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ExamFormScreen()));
            },
          )
        ],
      ),
      body: ListView(),
    );
  }
}
