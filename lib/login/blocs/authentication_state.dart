part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {}

class AuthenticationUninitialized extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationFailed extends AuthenticationState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class AuthenticationUnauthenticated extends AuthenticationState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class AuthenticationProcessing extends AuthenticationState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class AuthenticationAuthenticated extends AuthenticationState {
  @override
  List<Object> get props => throw UnimplementedError();
}
