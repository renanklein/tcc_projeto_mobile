part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  
}

class AppStarted extends AuthenticationEvent{
  BuildContext context;

  AppStarted({@required this.context});
}

class LoggedIn extends AuthenticationEvent{
  IdTokenResult token;
  BuildContext context;

  LoggedIn({@required this.token, @required this.context});
}

class LoggedOut extends AuthenticationEvent{}
