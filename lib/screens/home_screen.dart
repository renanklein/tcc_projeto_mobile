import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/widget/drawer.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu principal"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: UserDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: IconButton(
          icon: Icon(
            Icons.mode_edit,
            color: Colors.white,
          ),
          color: Theme.of(context).primaryColor,
          onPressed: (){},
        ),
      ),
    );
  }
}