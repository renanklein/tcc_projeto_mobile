part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  
}

class AppStarted extends AuthenticationEvent{
  BuildContext context;

  AppStarted({@required this.context});
}

class LoggedIn extends AuthenticationEvent{
  IdTokenResult token;

  LoggedIn({@required IdTokenResult token});
}

class LoggedOut extends AuthenticationEvent{}
