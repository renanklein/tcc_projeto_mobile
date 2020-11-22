part of 'pacient_bloc.dart';

class AppointmentsLoading extends PacientState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class AppointmentLoadEventSuccess extends PacientState {
  List<AppointmentModel> _appointmentsLoaded;

  AppointmentLoadEventSuccess(List<AppointmentModel> appointments) {
    this._appointmentsLoaded = appointments;
  }

  List<AppointmentModel> get appointmentsLoaded => this._appointmentsLoaded;

  @override
  List<Object> get props => throw UnimplementedError();
}
