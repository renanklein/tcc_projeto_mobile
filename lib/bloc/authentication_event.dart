part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  
}

class AppStarted extends AuthenticationEvent{

}

class LoggedIn extends AuthenticationEvent{
  IdTokenResult token;

  LoggedIn({@required IdTokenResult token});
}

class LoggedOut extends AuthenticationEvent{}
