import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/home/drawer.dart';
import 'package:tcc_projeto_app/home/tiles/home_card_tile.dart';
import 'package:tcc_projeto_app/login/blocs/authentication_bloc.dart';
import 'package:tcc_projeto_app/login/models/user_model.dart';
import 'package:tcc_projeto_app/login/screens/login_screen.dart';
import 'package:tcc_projeto_app/routes/constants.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

class HomeScreen extends StatefulWidget {
  final _userModel = Injector.appInstance.get<UserModel>();
  final authenticationBloc = Injector.appInstance.get<AuthenticationBloc>();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel model;

  UserModel get userModel => this.widget._userModel;
  AuthenticationBloc get authenticationBloc => this.widget.authenticationBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Eventos Agendados"),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0.0,
        ),
        drawer: UserDrawer(
          userModel: this.userModel,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: IconButton(
            icon: Icon(
              Icons.mode_edit,
              color: Colors.white,
            ),
            color: Theme.of(context).primaryColor,
            onPressed: () async {
              Navigator.of(context).pushReplacementNamed(calendarRoute);
            },
          ),
        ),
        body: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) async {
            if (state is AuthenticationUnauthenticated) {
              await Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            }
          },
          child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            bloc: this.authenticationBloc,
            builder: (context, state) {
              return Container(
                color: Theme.of(context).primaryColor,
                child: _createCardList(),
              );
            },
          ),
        ));
  }

  Widget _createCardList() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
      child: ListView(
        //TODO: Mostrar Eventos Agendados
        children: <Widget>[
          HomeCardTile(
            title: "Lorem",
            textBody: "lorem ipsum bla bla ",
          ),
          LayoutUtils.buildVerticalSpacing(16.0),
          HomeCardTile(
            title: "Lorem",
            textBody: "lorem ipsum bla bla ",
          ),
          LayoutUtils.buildVerticalSpacing(16.0),
          HomeCardTile(
            title: "Lorem",
            textBody: "lorem ipsum bla bla ",
          ),
          LayoutUtils.buildVerticalSpacing(16.0),
          HomeCardTile(
            title: "Lorem",
            textBody: "lorem ipsum bla bla ",
          ),
          LayoutUtils.buildVerticalSpacing(16.0),
          HomeCardTile(
            title: "Lorem",
            textBody: "lorem ipsum bla bla ",
          ),
        ],
      ),
    );
  }
}
