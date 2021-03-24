import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/exams/screens/exam_model_screen.dart';
import 'package:tcc_projeto_app/home/tiles/drawer_tile.dart';
import 'package:tcc_projeto_app/login/blocs/authentication_bloc.dart';
import 'package:tcc_projeto_app/login/models/user_model.dart';
import 'package:tcc_projeto_app/login/screens/assistant_registration_screen.dart';
import 'package:tcc_projeto_app/login/screens/login_screen.dart';

class UserDrawer extends StatefulWidget {
  final _userModel = Injector.appInstance.get<UserModel>();
  @override
  _UserDrawerState createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  AuthenticationBloc authenticationBloc;

  UserModel get userModel => this.widget._userModel;

  @override
  void initState() {
    this.authenticationBloc = Injector.appInstance.get<AuthenticationBloc>();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 16.0,
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        cubit: this.authenticationBloc,
        builder: (context, state) {
          /* return  FutureBuilder(
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return LayoutUtils.buildCircularProgressIndicator(context);
                  } else { */
          return ListView(
            children: <Widget>[
              _createDrawerHeader(this.userModel, context),
              (userModel.getAccess == "MEDIC")
                  ? DrawerTile(
                      icon: Icons.event_note,
                      text: "Modelo de exames",
                      onTapCallback: _navigateToExameScreen,
                    )
                  : Text(''),
              (userModel.getAccess == "MEDIC")
                  ? DrawerTile(
                      icon: Icons.event_note,
                      text: "Cadastrar Secretária",
                      onTapCallback: _navigateToAssistantRegistrationScreen,
                    )
                  : Text(''),
              DrawerTile(
                icon: Icons.info,
                text: "Relatorios",
                onTapCallback: null,
              ),
              Divider(),
              DrawerTile(
                icon: Icons.bug_report,
                text: "Relatar Erros",
                onTapCallback: null,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _createDrawerHeader(UserModel model, BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(image: _buildHeaderImage()),
      child: Center(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _buildAvatarImage(),
                SizedBox(
                  width: 30.0,
                ),
                _buildUserName(model),
              ],
            ),
            _buildSignoutButton(authenticationBloc)
          ],
        ),
      ),
    );
  }

  DecorationImage _buildHeaderImage() {
    return DecorationImage(
        image: AssetImage("assets/images/drawer_header.jpg"),
        fit: BoxFit.cover);
  }

  Widget _buildAvatarImage() {
    return CircleAvatar(
        radius: 40.0,
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage("assets/images/avatar_placeholder.jpg"));
  }

  Widget _buildUserName(UserModel model) {
    return Text(
      "${model.name ?? "Bemvindo, usuário !"}",
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.w500, fontSize: 25.0),
    );
  }

  Widget _buildSignoutButton(AuthenticationBloc authenticationBloc) {
    return TextButton(
      child: Text(
        "Sair",
        style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w300,
            color: Colors.grey[300]),
      ),
      onPressed: () async {
        this.authenticationBloc.add(LoggedOut());
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      },
    );
  }

  void _navigateToExameScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ExamModelsScreen(),
      ),
    );
  }

  void _navigateToAssistantRegistrationScreen() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => AssistantRegistrationScreen()));
  }
}
