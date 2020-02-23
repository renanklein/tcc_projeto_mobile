part of 'authentication_bloc.dart';


abstract class AuthenticationState extends Equatable {
  
}

class AuthenticationInitial extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationFailed extends AuthenticationState{}

class AuthenticationUnauthenticated extends AuthenticationState{}

class AuthenticationProcessing extends AuthenticationState{}

class AuthenticationAuthenticated extends AuthenticationState{}
