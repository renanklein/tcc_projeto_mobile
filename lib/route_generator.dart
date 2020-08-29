import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/agenda/screens/calendar.dart';
import 'package:tcc_projeto_app/exams/exam_form_screen.dart';
import 'package:tcc_projeto_app/exams/exam_screen.dart';
import 'package:tcc_projeto_app/home/screen/dashboard.dart';
import 'package:tcc_projeto_app/home/screen/home_screen.dart';
import 'package:tcc_projeto_app/login/repositories/user_repository.dart';
import 'package:tcc_projeto_app/med_record/screens/list_med_record_screen.dart';
import 'package:tcc_projeto_app/pacient/screens/create_pacient_screen.dart';
import 'package:tcc_projeto_app/pacient/screens/list_pacient_screen.dart';
import 'package:tcc_projeto_app/pacient/screens/pacient_detail_screen.dart';
import 'package:tcc_projeto_app/pacient/screens/wait_list_screen.dart';

class RouteGenerator {
  GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  void pop() {
    return _navigationKey.currentState.pop();
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    String uid;
    final args = settings.arguments;
    final userRepo = Injector.appInstance.getDependency<UserRepository>();
    userRepo.getUser().then((user) => uid = user.uid);

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Dashboard());
        break;
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeScreen());
        break;
      case '/exam':
        return MaterialPageRoute(builder: (_) => ExamFormScreen());
        break;
      case '/pacients':
        return MaterialPageRoute(builder: (_) => ListPacientScreen());
        break;
      case '/calendar':
        return MaterialPageRoute(
            builder: (_) => UserCalendar(
                  uid: uid,
                ));
        break;
      case '/createPacient':
        return MaterialPageRoute(builder: (_) => CreatePacientScreen());
        break;
      case '/waitList':
        return MaterialPageRoute(builder: (_) => WaitList());
        break;
      case '/pacientDetail':
        return MaterialPageRoute(builder: (_) => PacientDetailScreen());
        break;
      case '/medRecord':
        return MaterialPageRoute(builder: (_) => ListMedRecordScreen());
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
