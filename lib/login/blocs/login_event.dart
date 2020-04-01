part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
}

class LoginButtonPressed extends LoginEvent{
  String email;
  String password;

  LoginButtonPressed({@required this.email, @required this.password});
}

class LoginResetPasswordButtonPressed extends LoginEvent{
  String email;

  LoginResetPasswordButtonPressed({@required this.email});
}

