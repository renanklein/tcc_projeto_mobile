import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/home/tiles/drawer_tile.dart';
import 'package:tcc_projeto_app/login/blocs/authentication_bloc.dart';
import 'package:tcc_projeto_app/login/models/user_model.dart';
import 'package:tcc_projeto_app/login/repositories/user_repository.dart';
import 'package:tcc_projeto_app/login/screens/login_screen.dart';
import 'package:tcc_projeto_app/routes/medRecordArguments.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

class UserDrawer extends StatefulWidget {
  final userRepository = Injector.appInstance.getDependency<UserRepository>();
  @override
  _UserDrawerState createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  AuthenticationBloc authenticationBloc;

  UserRepository get userRepository => this.widget.userRepository;

  UserModel userModel;

  @override
  void initState() {
    this.authenticationBloc =
        Injector.appInstance.getDependency<AuthenticationBloc>();
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
              return FutureBuilder(
                future: _setUserModel(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return LayoutUtils.buildCircularProgressIndicator(context);
                  } else {
                    return ListView(
                      children: <Widget>[
                        _createDrawerHeader(this.userModel, context),
                        DrawerTile(
                          icon: Icons.person,
                          text: "Pacientes",
                          onTapCallback: _navigateToPacientScreen,
                        ),
                        DrawerTile(
                          icon: Icons.event_note,
                          text: "Exames",
                          onTapCallback: _navigateToExameScreen,
                        ),
                        DrawerTile(
                          icon: Icons.assignment,
                          text: "Prontuario",
                          onTapCallback: _navigateToMedRecordScreen,
                        ),
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
                  }
                },
              );
            }));
  }

  Future<void> _setUserModel() async {
    final user = this.userRepository.getUser();
    final userData = await this.userRepository.getUserData(user.uid);
    this.userModel = UserModel(
        email: userData.data()["email"],
        name: userData.data()["name"],
        uid: user.uid);
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
    return FlatButton(
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
            MaterialPageRoute(builder: (context) => LoginScreen()));
      },
    );
  }

// TODO: Verificar o Link de Exame seguindo pela lista de pacientes
// TODO: Fazer arquivo de link???

  void _navigateToExameScreen() {
    Navigator.of(context).pushNamed(
      '/medRecord',
      arguments: MedRecordArguments(
          index: 'examScreen', pacientCpf: '', pacientSalt: ''),
    );
  }

  void _navigateToPacientScreen() {
    Navigator.of(context).pushNamed(
      '/pacients',
      arguments: 'drawer',
    );
  }

  void _navigateToMedRecordScreen() {
    Navigator.of(context).pushNamed(
      '/medRecord',
      arguments: MedRecordArguments(index: '', pacientCpf: '', pacientSalt: ''),
    );
  }
}
