import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/agenda/screens/calendar.dart';
import 'package:tcc_projeto_app/home/drawer.dart';
import 'package:tcc_projeto_app/home/tiles/home_card_tile.dart';
import 'package:tcc_projeto_app/login/blocs/authentication_bloc.dart';
import 'package:tcc_projeto_app/login/models/user_model.dart';
import 'package:tcc_projeto_app/login/repositories/user_repository.dart';
import 'package:tcc_projeto_app/login/screens/login_screen.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';


class HomeScreen extends StatefulWidget {
  final userRepository = Injector.appInstance.getDependency<UserRepository>();

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
  void dispose() {
    this._authenticationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => this._authenticationBloc,
      child: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {},
        child: BlocBuilder(
          bloc: this._authenticationBloc,
          builder: (context, state) {
            if(state is AuthenticationUnauthenticated){
              return LoginScreen();
            }

            return Scaffold(
              appBar: AppBar(
                title: Text("Menu principal"),
                centerTitle: true,
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 0.0,
              ),
              drawer: UserDrawer(),
              floatingActionButton: FloatingActionButton(
                onPressed: () {},
                child: IconButton(
                  icon: Icon(
                    Icons.mode_edit,
                    color: Colors.white,
                  ),
                  color: Theme.of(context).primaryColor,
                  onPressed: () async{
                    var user  = await this.userRepository.getUser();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => UserCalendar(uid: user.uid,)));
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
