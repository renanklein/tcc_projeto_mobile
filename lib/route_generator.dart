import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/repository/pacient_repository.dart';
import 'package:tcc_projeto_app/repository/user_repository.dart';
import 'package:tcc_projeto_app/ui/screens/create_pacient_screen.dart';
import 'package:tcc_projeto_app/ui/screens/dashboard.dart';
import 'package:tcc_projeto_app/ui/screens/home_screen.dart';
import 'package:tcc_projeto_app/ui/screens/list_pacient_screen.dart';
import 'package:tcc_projeto_app/ui/screens/pacient_detail_screen.dart';
import 'package:tcc_projeto_app/ui/screens/wait_list.dart';
import 'package:tcc_projeto_app/ui/widget/calendar.dart';

class RouteGenerator {
  GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  bool pop() {
    return _navigationKey.currentState.pop();
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    PacientRepository pacientRepository = new PacientRepository();

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Dashboard());
        break;
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeScreen());
        break;
      case '/pacients':
        return MaterialPageRoute(builder: (_) => ListPacientScreen());
        break;
      case '/calendar':
        return MaterialPageRoute(builder: (_) => UserCalendar());
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
