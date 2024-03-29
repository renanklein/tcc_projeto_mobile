import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/home/drawer.dart';
import 'package:tcc_projeto_app/login/blocs/authentication_bloc.dart';
import 'package:tcc_projeto_app/login/models/user_model.dart';
import 'package:tcc_projeto_app/login/screens/login_screen.dart';
import 'package:tcc_projeto_app/pacient/blocs/pacient_bloc.dart';
import 'package:tcc_projeto_app/pacient/route_appointment_arguments.dart';
import 'package:tcc_projeto_app/routes/constants.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  UserModel model;
  AuthenticationBloc _authenticationBloc;

  UserModel _userModel;

  @override
  void initState() {
    this._authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    this._userModel = Injector.appInstance.get<UserModel>();
    BlocProvider.of<PacientBloc>(context).pacientRepository.userId =
        this._userModel.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      bloc: this._authenticationBloc,
      listener: (context, state) {
        if (state is AuthenticationUnauthenticated) {
          return LoginScreen();
        } else if (state is AuthenticationAuthenticated) {
          this._userModel = Injector.appInstance.get<UserModel>();
        }
      },
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        bloc: this._authenticationBloc,
        builder: (context, state) {
          if (state is AuthenticationProcessing) {
            return LayoutUtils.buildCircularProgressIndicator(context);
          }
          return Scaffold(
            appBar: AppBar(
              title: Text("Dashboard"),
              centerTitle: true,
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 0.0,
            ),
            drawer: UserDrawer(
              userModel: this._userModel,
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Wrap(
                runSpacing: 15.0,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            createOrEditPacient,
                            arguments: RouteAppointmentArguments(
                                routePath: 'Dashboard'),
                          );
                        },
                        child: _dashboardItem(
                          Icons.library_add,
                          'Cadastrar Paciente',
                          0xFF1A237E,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            pacientsRoute,
                            arguments: this._userModel.uid,
                          );
                        },
                        child: _dashboardItem(
                            Icons.archive, 'Listar Pacientes', 0xFF1A237E),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            calendarRoute,
                            arguments: 'Dashboard',
                          );
                        },
                        child: _dashboardItem(
                          Icons.event,
                          'Agenda',
                          0xFF1A237E,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            confirmEvent,
                            arguments: 'Dashboard',
                          );
                        },
                        child: _dashboardItem(
                          Icons.library_add,
                          'Confirmar consultas',
                          0xFF1A237E,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            appointmentsViewRoute,
                            arguments: this._userModel.uid,
                          );
                        },
                        child: _dashboardItem(
                          Icons.library_add,
                          'Próximos Atendimentos',
                          0xFF1A237E,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: _dashboardItem(
                            Icons.archive, 'Desativado', 0xFF1A237E),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _dashboardItem(IconData icon, String heading, int color) {
    return Material(
      color: Color(0xFF84FFFF),
      elevation: 14.0,
      shadowColor: Color(0x802196F3),
      borderRadius: BorderRadius.circular(24.0),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width / 2.8,
            height: 130.0,
            child: Wrap(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          heading,
                          overflow: TextOverflow.visible,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(color),
                            fontSize: 19.0,
                            fontWeight: FontWeight.w600,
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
      ),
    );
  }
}
