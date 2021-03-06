import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/agenda/screens/calendar.dart';
import 'package:tcc_projeto_app/agenda/screens/confirm_events_screen.dart';
import 'package:tcc_projeto_app/home/screen/dashboard.dart';
import 'package:tcc_projeto_app/home/screen/home_screen.dart';
import 'package:tcc_projeto_app/login/models/user_model.dart';
import 'package:tcc_projeto_app/login/screens/assistant_registration_screen.dart';
import 'package:tcc_projeto_app/med_record/screens/create_diagnosis_screen.dart';
import 'package:tcc_projeto_app/med_record/screens/list_med_record_screen.dart';
import 'package:tcc_projeto_app/med_record/screens/create_pre_dignosis_screen.dart';
import 'package:tcc_projeto_app/pacient/route_appointment_arguments.dart';
import 'package:tcc_projeto_app/pacient/models/pacient_model.dart';
import 'package:tcc_projeto_app/pacient/screens/create_or_edit_pacient_screen.dart';
import 'package:tcc_projeto_app/pacient/screens/list_pacient_screen.dart';
import 'package:tcc_projeto_app/pacient/screens/pacient_detail_screen.dart';
import 'package:tcc_projeto_app/pacient/screens/appointments_wait_list_screen.dart';
import 'package:tcc_projeto_app/routes/constants.dart';
import 'package:tcc_projeto_app/routes/medRecordArguments.dart';

class RouteGenerator {
  GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  void pop() {
    return _navigationKey.currentState.pop();
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    //final MedRecordArguments mDArgs = settings.arguments as Type;
    final userModel = Injector.appInstance.get<UserModel>();

    switch (settings.name) {
      case dashboardRoute:
        return MaterialPageRoute(builder: (_) => Dashboard());
        break;
      case homeRoute:
        return MaterialPageRoute(builder: (_) => HomeScreen());
        break;
      case assistantRegistrationRoute:
        if (userModel.getAccess == "MEDIC") {
          return MaterialPageRoute(
              builder: (_) => AssistantRegistrationScreen());
        } else {
          return _notAllowedAccess();
        }
        break;
      case pacientsRoute:
        String uid;
        if (userModel.getAccess == "ASSISTANT") {
          uid = userModel.getMedicId;
        } else {
          uid = userModel.uid;
        }
        return MaterialPageRoute(
          builder: (_) => ListPacientScreen(
            userUid: uid,
          ),
        );
        break;
      case confirmEvent:
        if (userModel.getAccess == "MEDIC") {
          return MaterialPageRoute(builder: (_) => ConfirmEventsScreen(""));
        } else {
          return _notAllowedAccess();
        }
        break;
      case createDiagnosisRoute:
        var pacientData = settings.arguments as PacientModel;
        if (userModel.getAccess == "MEDIC") {
          return MaterialPageRoute(builder: (_) => CreateDiagnosisScreen(pacientModel: pacientData,));
        } else {
          return _notAllowedAccess();
        }
        break;
      case calendarRoute:
        String uid;
        if (userModel.getAccess == "ASSISTANT") {
          uid = userModel.getMedicId;
        } else {
          uid = userModel.uid;
        }
        return MaterialPageRoute(
          builder: (_) => UserCalendar(
            uid: uid,
          ),
        );

        break;
      case createOrEditPacient:
        var arguments = settings.arguments as RouteAppointmentArguments;

        return MaterialPageRoute(
            builder: (_) => CreateOrEditPacientScreen(
                  path: arguments?.routePath,
                  appointmentModel: arguments?.appointmentModel,
                  pacientModel: arguments?.pacientModel,
                ));
        break;
      case pacientDetailRoute:
        var pacientData = settings.arguments as PacientModel;
        return MaterialPageRoute(
          builder: (_) => PacientDetailScreen(
            pacient: pacientData,
          ),
        );
        break;
      case appointmentsViewRoute:
        String uid;
        if (userModel.getAccess == "ASSISTANT") {
          uid = userModel.getMedicId;
        } else {
          uid = userModel.uid;
        }
        return MaterialPageRoute(
          builder: (_) => AppointmentsWaitListScreen(
            userUid: uid,
          ),
        );
        break;
      case medRecordRoute:
        if (userModel.getAccess == "MEDIC") {
          var data = settings.arguments as MedRecordArguments;
          return MaterialPageRoute(
            builder: (_) => MedRecordScreen(
              medRecordArguments: data,
            ),
          );
        } else {
          return _notAllowedAccess();
        }
        break;
      case preDiagnosisRoute:
        var data = settings.arguments as RouteAppointmentArguments;
        return MaterialPageRoute(
          builder: (_) => CreatePreDiagnosisScreen(
            pacient: data?.pacientModel,
            appointmentModel: data?.appointmentModel,
          ),
        );
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

  static Route<dynamic> _notAllowedAccess() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Acesso Não Permitido'),
        ),
        body: Center(
          child: Text(
              'Seu Nível de Acesso não permite o acesso a esse conteúdo. Por favor, retorne a página anterior.'),
        ),
      );
    });
  }
}
