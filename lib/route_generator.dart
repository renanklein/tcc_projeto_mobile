import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/ui/screens/dashboard.dart';
import 'package:tcc_projeto_app/ui/screens/home_screen.dart';
import 'package:tcc_projeto_app/ui/screens/view_pacient_screen.dart';
import 'package:tcc_projeto_app/ui/widget/calendar.dart';

class RouteGenerator {
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
        return MaterialPageRoute(builder: (_) => ViewPacientcreen());
        break;
      case '/calendar':
        return MaterialPageRoute(builder: (_) => UserCalendar());
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
