import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/agenda/blocs/agenda_bloc.dart';
import 'package:tcc_projeto_app/agenda/repositories/agenda_repository.dart';
import 'package:tcc_projeto_app/exams/blocs/exam_bloc.dart';
import 'package:tcc_projeto_app/exams/repositories/exam_repository.dart';
import 'package:tcc_projeto_app/home/screen/dashboard.dart';
import 'package:tcc_projeto_app/login/blocs/authentication_bloc.dart';
import 'package:tcc_projeto_app/login/blocs/login_bloc.dart';
import 'package:tcc_projeto_app/login/blocs/signup_bloc.dart';
import 'package:tcc_projeto_app/login/repositories/user_repository.dart';
import 'package:tcc_projeto_app/login/screens/login_screen.dart';
import 'package:tcc_projeto_app/med_record/blocs/med_record_bloc.dart';
import 'package:tcc_projeto_app/med_record/repositories/med_record_repository.dart';
import 'package:tcc_projeto_app/pacient/blocs/pacient_bloc.dart';
import 'package:tcc_projeto_app/pacient/repositories/pacient_repository.dart';
import 'package:tcc_projeto_app/routes/route_generator.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' as flutter_foundation;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

Future<dynamic> onBackgroundMessage(Map<String, dynamic> message) async {
  print(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (flutter_foundation.kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }

  runApp(MyApp());
}

class _MyAppState extends State<MyApp> {
  AuthenticationBloc authenticationBloc;

  @override
  void initState() {
    registerDependencies();
    configureNotificationsType(context);
    this.authenticationBloc =
        Injector.appInstance.getDependency<AuthenticationBloc>();

    this.authenticationBloc.add(AppStarted(context: context));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => this.authenticationBloc,
        ),
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(
            userRepository:
                Injector.appInstance.getDependency<UserRepository>(),
            authenticationBloc: this.authenticationBloc,
          ),
        ),
        BlocProvider<SignupBloc>(
          create: (context) => SignupBloc(
            userRepository:
                Injector.appInstance.getDependency<UserRepository>(),
            authenticationBloc: this.authenticationBloc,
          ),
        ),
        BlocProvider<AgendaBloc>(
            create: (context) => AgendaBloc(
                agendaRepository:
                    Injector.appInstance.getDependency<AgendaRepository>())),
        BlocProvider<ExamBloc>(
          create: (context) => ExamBloc(
              examRepository:
                  Injector.appInstance.getDependency<ExamRepository>()),
        ),
        BlocProvider<PacientBloc>(
            create: (context) => PacientBloc(
                pacientRepository:
                    Injector.appInstance.getDependency<PacientRepository>())),
        BlocProvider<MedRecordBloc>(
            create: (context) => MedRecordBloc(
                medRecordRepository:
                    Injector.appInstance.getDependency<MedRecordRepository>(),
                examRepository:
                    Injector.appInstance.getDependency<ExamRepository>()))
      ],
      child: MaterialApp(
        title: "Projeto tcc",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.blueGrey),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [const Locale('pt', 'BR')],
        onGenerateRoute: RouteGenerator.generateRoute,
        home: BlocBuilder(
          cubit: this.authenticationBloc,
          builder: (BuildContext context, AuthenticationState state) {
            if (state is AuthenticationUnauthenticated) {
              return LoginScreen();
            } else if (state is AuthenticationAuthenticated) {
              return Dashboard();
            } else if (state is AuthenticationProcessing ||
                state is AuthenticationUninitialized) {
              return LayoutUtils.buildCircularProgressIndicator(context);
            }
            return Container(
              child: LayoutUtils.buildCircularProgressIndicator(context),
            );
          },
        ),
      ),
    );
  }

  void registerDependencies() {
    Injector injector = Injector.appInstance;

    injector.registerSingleton<UserRepository>((_) => UserRepository());

    injector.registerSingleton<PacientRepository>((_) => PacientRepository());

    injector
        .registerSingleton<MedRecordRepository>((_) => MedRecordRepository());

    injector.registerSingleton<ExamRepository>((_) => ExamRepository());

    injector.registerSingleton((_) => AgendaRepository());

    injector.registerSingleton((_) => FirebaseMessaging());

    injector.registerSingleton((_) => AuthenticationBloc(
          userRepository: injector.getDependency<UserRepository>(),
        ));
  }

  void configureNotificationsType(BuildContext context) async {
    var _fcm = Injector.appInstance.getDependency<FirebaseMessaging>();
    _fcm.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
        },
        onBackgroundMessage: onBackgroundMessage);
  }
}
