import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/agenda/screens/calendar.dart';
import 'package:tcc_projeto_app/home/screen/dashboard.dart';
import 'package:tcc_projeto_app/home/screen/home_screen.dart';
import 'package:tcc_projeto_app/pacient/screens/create_pacient_screen.dart';
import 'package:tcc_projeto_app/pacient/screens/list_pacient_screen.dart';
import 'package:tcc_projeto_app/pacient/screens/pacient_detail_screen.dart';
import 'package:tcc_projeto_app/pacient/screens/wait_list_screen.dart';

class RouteGenerator {
  GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  bool pop() {
    return _navigationKey.currentState.pop();
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

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
