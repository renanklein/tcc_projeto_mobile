import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/model/user_model.dart';
import 'package:tcc_projeto_app/repository/user_repository.dart';
import 'package:tcc_projeto_app/tiles/home_card_tile.dart';
import 'package:tcc_projeto_app/widget/calendar.dart';
import 'package:tcc_projeto_app/widget/drawer.dart';

class HomeScreen extends StatefulWidget {
  final userRepository;

  HomeScreen({@required this.userRepository}) : assert(userRepository != null);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel model;

  UserRepository get userRepository => this.widget.userRepository;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu principal"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
      ),
      drawer: UserDrawer(userRepository: userRepository),
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