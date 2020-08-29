part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {}

class AppStarted extends AuthenticationEvent {
  final context;

  AppStarted({@required this.context});

  @override
  List<Object> get props => [];
}

class LoggedIn extends AuthenticationEvent {
  final token;
  final context;

  LoggedIn({@required this.token, @required this.context});

  @override
  List<Object> get props => [];
}

class LoggedOut extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}
