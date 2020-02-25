part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginSucceded extends LoginState{} 

class LoginProcessing extends LoginState{}

class LoginFailure extends LoginState{}

class LoginPasswordReset extends LoginState{}

