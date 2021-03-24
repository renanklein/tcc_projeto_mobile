part of 'signup_bloc.dart';

abstract class SignupEvent extends Equatable {}

class SignupButtonPressed extends SignupEvent {
  final name;
  final email;
  final password;
  final access;
  final context;
  final medicId;

  SignupButtonPressed({
    @required this.name,
    @required this.email,
    @required this.password,
    @required this.access,
    @required this.context,
    this.medicId,
  });

  @override
  List<Object> get props => [];
}
