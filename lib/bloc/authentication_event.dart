part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  
}

class AppStarted extends AuthenticationEvent{

}

class LoggedIn extends AuthenticationEvent{
  String token;

  LoggedIn({@required String token});
}

class LoggedOut extends AuthenticationEvent{}
