import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tcc_projeto_app/bloc/authentication_bloc.dart';
import 'package:tcc_projeto_app/repository/agenda_repository.dart';
import 'package:tcc_projeto_app/repository/user_repository.dart';
import 'package:tcc_projeto_app/screens/home_screen.dart';
import 'package:tcc_projeto_app/screens/login_screen.dart';



class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  
  Injector injector = Injector.appInstance;

  injector.registerSingleton<UserRepository>((_) => UserRepository());
  
  var user = await injector.getDependency<UserRepository>().getUser();
  injector.registerSingleton((_) => AgendaRepository(userId: user.uid));

  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class _MyAppState extends State<MyApp> {
  AuthenticationBloc authenticationBloc;
  final _userRepository = Injector.appInstance.getDependency<UserRepository>();

  @override
  void initState() {
    this.authenticationBloc = AuthenticationBloc();
    this.authenticationBloc.add(AppStarted());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      create: (context) => this.authenticationBloc,
      child: MaterialApp(
        title: "Projeto tcc",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.blueGrey),
        home: BlocBuilder(
          bloc: this.authenticationBloc,
          builder: (BuildContext context, AuthenticationState state){
            if(state is AuthenticationUnauthenticated){
              return LoginScreen();
            }
            else if (state is AuthenticationAuthenticated){
              return HomeScreen();
            }
            else if(state is AuthenticationProcessing || state is AuthenticationUninitialized){
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
