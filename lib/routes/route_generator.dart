import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/agenda/screens/calendar.dart';
import 'package:tcc_projeto_app/exams/screens/exam_form_screen.dart';
import 'package:tcc_projeto_app/home/screen/dashboard.dart';
import 'package:tcc_projeto_app/home/screen/home_screen.dart';
import 'package:tcc_projeto_app/login/repositories/user_repository.dart';
import 'package:tcc_projeto_app/med_record/screens/list_med_record_screen.dart';
import 'package:tcc_projeto_app/pacient/screens/create_pacient_screen.dart';
import 'package:tcc_projeto_app/pacient/screens/list_pacient_screen.dart';
import 'package:tcc_projeto_app/pacient/screens/pacient_detail_screen.dart';
import 'package:tcc_projeto_app/pacient/screens/wait_list_screen.dart';
import 'package:tcc_projeto_app/routes/constants.dart';
import 'package:tcc_projeto_app/routes/medRecordArguments.dart';

class RouteGenerator {
  GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  void pop() {
    return _navigationKey.currentState.pop();
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    String uid;
    //final MedRecordArguments mDArgs = settings.arguments as Type;
    final userRepo = Injector.appInstance.getDependency<UserRepository>();
    uid = userRepo.getUser().uid;

    switch (settings.name) {
      case dashboardRoute:
        return MaterialPageRoute(builder: (_) => Dashboard());
        break;
      case homeRoute:
        return MaterialPageRoute(builder: (_) => HomeScreen());
        break;
      case createExamRoute:
        return MaterialPageRoute(builder: (context) => ExamFormScreen());
        break;
      case pacientsRoute:
        return MaterialPageRoute(builder: (_) => ListPacientScreen());
        break;
      case calendarRoute:
        return MaterialPageRoute(
            builder: (_) => UserCalendar(
                  uid: uid,
                ));
        break;
      case createPacientRoute:
        return MaterialPageRoute(builder: (_) => CreatePacientScreen());
        break;
      case waitListRoute:
        return MaterialPageRoute(builder: (_) => WaitList());
        break;
      case pacientDetailRoute:
        return MaterialPageRoute(builder: (_) => PacientDetailScreen());
        break;
      case medRecordRoute:
        var data = settings.arguments as MedRecordArguments;
        return MaterialPageRoute(
            builder: (_) => MedRecordScreen(
                  medRecordArguments: data,
                ));
        break;
      case '/newPacientDetail':
        //return MaterialPageRoute(builder: (_) => NewPacientDetailScreen());
        break;
      default:
        return _errorRoute();
        break;
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Erro de Rota'),
        ),
      );
    });
  }
}
