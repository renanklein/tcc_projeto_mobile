part of 'signup_bloc.dart';

abstract class SignupEvent extends Equatable {}

class SignupButtonPressed extends SignupEvent {
  final name;
  final email;
  final password;
  final context;

  SignupButtonPressed(
      {@required this.name,
      @required this.email,
      @required this.password,
      @required this.context});

  @override
  List<Object> get props => throw UnimplementedError();
}
