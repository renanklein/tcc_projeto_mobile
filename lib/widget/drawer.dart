import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tcc_projeto_app/model/user_model.dart';
import 'package:tcc_projeto_app/repository/user_repository.dart';
import 'package:tcc_projeto_app/screens/login_screen.dart';
import 'package:tcc_projeto_app/tiles/drawer_tile.dart';

class UserDrawer extends StatelessWidget {
  UserRepository userRepository;

  UserDrawer({@required this.userRepository}) : assert(userRepository != null);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        elevation: 16.0,
        child: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if (model == null || model.isLoading) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen(userRepository : this.userRepository)));
            } else {
              return ListView(
                children: <Widget>[
                  _createDrawerHeader(model, context),
                  DrawerTile(
                      icon: Icons.person,
                      text: "Pacientes",
                      onTapCallback: null),
                  DrawerTile(
                      icon: Icons.event_note,
                      text: "Exames",
                      onTapCallback: null),
                  DrawerTile(
                      icon: Icons.assignment,
                      text: "Anamnese",
                      onTapCallback: null),
                  DrawerTile(
                      icon: Icons.info,
                      text: "Relatorios",
                      onTapCallback: null),
                  Divider(),
                  DrawerTile(
                      icon: Icons.bug_report,
                      text: "Relatar Erros",
                      onTapCallback: null),
                ],
              );
            }
          },
        ));
  }

  Widget _createDrawerHeader(UserModel model, BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/drawer_header.jpg"),
            fit: BoxFit.cover),
      ),
      child: Center(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                CircleAvatar(
                    radius: 40.0,
                    backgroundColor: Colors.transparent,
                    backgroundImage:
                        AssetImage("assets/images/avatar_placeholder.jpg")),
                SizedBox(
                  width: 30.0,
                ),
                Text(
                  "${model.userData["name"] ?? "Bemvindo, usuário !"}",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 25.0),
                )
              ],
            ),
            FlatButton(
              child: Text(
                "Sair",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey[300]
                ),
              ),
              onPressed: (){
                model.logOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen(userRepository: this.userRepository,))
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
