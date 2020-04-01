import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tcc_projeto_app/agenda/repositories/agenda_repository.dart';
import 'package:tcc_projeto_app/home/screen/home_screen.dart';
import 'package:tcc_projeto_app/login/blocs/authentication_bloc.dart';
import 'package:tcc_projeto_app/login/blocs/login_bloc.dart';
import 'package:tcc_projeto_app/login/blocs/signup_bloc.dart';
import 'package:tcc_projeto_app/login/repositories/user_repository.dart';
import 'package:tcc_projeto_app/login/screens/login_screen.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';





class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  
  Injector injector = Injector.appInstance;

  injector.registerSingleton<UserRepository>((_) => UserRepository());
  injector.registerSingleton((_) => AgendaRepository());

  injector.registerDependency((_) => AuthenticationBloc(
    userRepository: injector.getDependency<UserRepository>()));

  injector.registerDependency((_) => LoginBloc(
    userRepository: injector.getDependency<UserRepository>(),
    authenticationBloc: injector.getDependency<AuthenticationBloc>()
  ));

  injector.registerDependency((_) => SignupBloc(
    userRepository: injector.getDependency<UserRepository>(),
    authenticationBloc: injector.getDependency<AuthenticationBloc>()
  ));

  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class _MyAppState extends State<MyApp> {
  AuthenticationBloc authenticationBloc;

  @override
  void initState() {
    this.authenticationBloc = Injector.appInstance.getDependency<AuthenticationBloc>();
    this.authenticationBloc.add(AppStarted());
    super.initState();
  }

  @override
  void dispose() {
    authenticationBloc.close();
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
             return LayoutUtils.buildCircularProgressIndicator(context);
            }
          },
        ),
      ),
    );
  }
}
