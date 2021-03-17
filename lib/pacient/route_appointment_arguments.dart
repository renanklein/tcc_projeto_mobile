import 'package:tcc_projeto_app/pacient/models/appointment_model.dart';
import 'package:tcc_projeto_app/pacient/models/pacient_model.dart';

class RouteAppointmentArguments {
  final AppointmentModel appointmentModel;
  final PacientModel pacientModel;
  final String routePath;
  RouteAppointmentArguments(
      {this.pacientModel, this.routePath, this.appointmentModel});
}
