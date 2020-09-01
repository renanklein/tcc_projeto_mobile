part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {}

class LoginButtonPressed extends LoginEvent {
  final email;
  final password;
  final context;

  LoginButtonPressed(
      {@required this.email, @required this.password, @required this.context});

  @override
  List<Object> get props => [];
}

class LoginResetPasswordButtonPressed extends LoginEvent {
  final email;

  LoginResetPasswordButtonPressed({@required this.email});

  @override
  List<Object> get props => [];
}
