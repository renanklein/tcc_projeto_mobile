import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/tiles/home_card_tile.dart';
import 'package:tcc_projeto_app/widget/calendar.dart';
import 'package:tcc_projeto_app/widget/drawer.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu principal"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
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
          onPressed: (){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => UserCalendar())
            );
          },
        ),
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: _createCardList(),
      ),
    );
  }

 //placeholder code, the data within cards should be from firebase
  Widget _createCardList(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: ListView(
      children: <Widget>[
        SizedBox(height: 16.0,),
        HomeCardTile(title: "Lorem", textBody: "lorem ipsum bla bla ",),

        SizedBox(height: 16.0,),
        HomeCardTile(title: "Lorem", textBody: "lorem ipsum bla bla ",),

        SizedBox(height: 16.0,),
        HomeCardTile(title: "Lorem", textBody: "lorem ipsum bla bla ",),

        SizedBox(height: 16.0,),
        HomeCardTile(title: "Lorem", textBody: "lorem ipsum bla bla ",),

        SizedBox(height: 16.0,),
        HomeCardTile(title: "Lorem", textBody: "lorem ipsum bla bla ",),
      ],
    ),
    );
  }
}