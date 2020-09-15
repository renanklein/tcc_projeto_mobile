import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcc_projeto_app/home/drawer.dart';
import 'package:tcc_projeto_app/login/blocs/authentication_bloc.dart';
import 'package:tcc_projeto_app/login/models/user_model.dart';
import 'package:tcc_projeto_app/login/screens/login_screen.dart';

class PacientDetailScreen extends StatefulWidget {
  @override
  _PacientDetailScreenState createState() => _PacientDetailScreenState();
}

class _PacientDetailScreenState extends State<PacientDetailScreen> {
  UserModel model;
  AuthenticationBloc _authenticationBloc;

  //UserRepository get userRepository => this.widget.userRepository;

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
          cubit: this._authenticationBloc,
          builder: (context, state) {
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
                    Icons.add,
                    color: Colors.white,
                  ),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.of(context).pushNamed('/newPacientDetail');
                  },
                ),
              ),
              body: SafeArea(child: pacientDetail(context)),
            );
          },
        ),
      ),
    );
  }
}

Widget pacientDetail(context) {
  return Row(
    children: <Widget>[
      pacientTabs(),
      pacientProfile(context),
    ],
  );
}

Widget pacientTabs() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      GestureDetector(
        //onTap: (){},
        child: Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(18),
            ),
          ),
          child: Center(
            child: Icon(
              Icons.add_alert,
              color: Colors.blue,
              size: 30.0,
              semanticLabel: 'texto acessibilidade',
            ),
          ),
        ),
      ),
      Container(
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(18),
          ),
        ),
        child: Center(
          child: Icon(
            Icons.add_alert,
            color: Colors.blue,
            size: 30.0,
            semanticLabel: 'texto acessibilidade',
          ),
        ),
      ),
    ],
  );
}

Widget pacientProfile(context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
    child: Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              constraints: BoxConstraints.expand(
                width: 90,
                height: 90,
              ),
              decoration:
                  BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
              child: Image.network(
                'https://image.freepik.com/vetores-gratis/perfil-de-avatar-de-homem-no-icone-redondo_24640-14044.jpg',
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.60,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'info paciente',
                    ),
                    Text(
                      'info paciente',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
