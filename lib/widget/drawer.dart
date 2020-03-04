import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcc_projeto_app/bloc/authentication_bloc.dart';
import 'package:tcc_projeto_app/model/user_model.dart';
import 'package:tcc_projeto_app/repository/user_repository.dart';
import 'package:tcc_projeto_app/screens/login_screen.dart';
import 'package:tcc_projeto_app/tiles/drawer_tile.dart';

class UserDrawer extends StatefulWidget {
  final userRepository;
  UserDrawer({@required this.userRepository}) : assert(userRepository != null);

  @override
  _UserDrawerState createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  AuthenticationBloc authenticationBloc;

  UserModel userModel;

  UserRepository get userRepository => this.widget.userRepository;

  @override
  void initState() {
    this.authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    this.authenticationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        elevation: 16.0,
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            bloc: this.authenticationBloc,
            builder: (context, state) {
              return FutureBuilder(
                future: _setUserModel(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    );
                  } else {
                    return ListView(
                      children: <Widget>[
                        _createDrawerHeader(this.userModel, context),
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
              );
            }));
  }

  Future<void> _setUserModel() async {
    final user = await this.userRepository.getUser();
    final userData = await this.userRepository.getUserData(user.uid);
    this.userModel =
        UserModel(email: userData.data["email"], name: userData.data["name"]);
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
                  "${model.name ?? "Bemvindo, usuário !"}",
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
                    color: Colors.grey[300]),
              ),
              onPressed: () async{
                this.authenticationBloc.add(LoggedOut());
                await Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) =>
                        LoginScreen(userRepository: userRepository)));
              },
            ),
          ],
        ),
      ),
    );
  }
}
