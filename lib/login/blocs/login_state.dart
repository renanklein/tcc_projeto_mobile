part of 'login_bloc.dart';

abstract class LoginState extends Equatable {}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginSucceded extends LoginState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class LoginProcessing extends LoginState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class LoginFailure extends LoginState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class LoginPasswordReset extends LoginState {
  @override
  List<Object> get props => throw UnimplementedError();
}
