part of 'pacient_bloc.dart';

class PacientDetailLoad extends PacientEvent {
  AppointmentModel _appointmentModel;

  PacientDetailLoad(AppointmentModel appointments) {
    this._appointmentModel = appointments;
  }

  @override
  List<Object> get props => throw UnimplementedError();
}
