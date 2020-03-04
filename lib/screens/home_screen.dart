import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcc_projeto_app/bloc/authentication_bloc.dart';
import 'package:tcc_projeto_app/model/user_model.dart';
import 'package:tcc_projeto_app/repository/user_repository.dart';
import 'package:tcc_projeto_app/screens/login_screen.dart';
import 'package:tcc_projeto_app/tiles/home_card_tile.dart';
import 'package:tcc_projeto_app/utils/LayoutUtils.dart';
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
            return LoginScreen(
              userRepository: userRepository,
            );
          }
        },
        child: BlocBuilder(
          bloc: this._authenticationBloc,
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Menu principal"),
                centerTitle: true,
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 0.0,
              ),
              drawer: UserDrawer(userRepository: userRepository),
              floatingActionButton: FloatingActionButton(
                onPressed: () {},
                child: IconButton(
                  icon: Icon(
                    Icons.mode_edit,
                    color: Colors.white,
                  ),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => UserCalendar()));
                  },
                ),
              ),
              body: Container(
                color: Theme.of(context).primaryColor,
                child: _createCardList(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _createCardList() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: ListView(
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
