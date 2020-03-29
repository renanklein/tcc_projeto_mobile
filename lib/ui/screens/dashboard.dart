import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/ui/widget/drawer.dart';
import 'package:tcc_projeto_app/bloc/authentication_bloc.dart';
import 'package:tcc_projeto_app/model/user_model.dart';
import 'package:tcc_projeto_app/repository/user_repository.dart';

import 'login_screen.dart';

class Dashboard extends StatefulWidget {
  final userRepository = Injector.appInstance.getDependency<UserRepository>();

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  UserModel model;
  AuthenticationBloc _authenticationBloc;

  UserRepository get userRepository => this.widget.userRepository;

  @override
  void initState() {
    this._authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => this._authenticationBloc,
      child: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationUnauthenticated) {
            return LoginScreen();
          }
        },
        child: BlocBuilder(
          bloc: this._authenticationBloc,
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Dashboard"),
                centerTitle: true,
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 0.0,
              ),
              drawer: UserDrawer(),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,                    
                      children: <Widget>[
                        GestureDetector (
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              '/pacients',
                              arguments: 'Dashboard',
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: _DashboardItem(Icons.archive, 'Listar Pacientes', 0xFF1A237E),
                          ),
                        ),
                      ]
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector (
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              '/calendar',
                              arguments: 'Dashboard',
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: _DashboardItem(Icons.event, 'Eventos', 0xFF1A237E),
                          ),
                        ),
                        _DashboardItem(Icons.library_add, 'TESTE3', 0xFF1A237E),
                      ]
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _DashboardItem (IconData icon, String heading, int color) {
    return Material(
      color: Color(0xFF84FFFF),
      elevation: 14.0,
      shadowColor: Color(0x802196F3),
      borderRadius: BorderRadius.circular(24.0),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        heading,
                        style: TextStyle(
                          color: Color(color),
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Color(color),
                    borderRadius: BorderRadius.circular(24.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}