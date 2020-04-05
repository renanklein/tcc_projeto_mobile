part of 'signup_bloc.dart';

abstract class SignupEvent extends Equatable {

}

class SignupButtonPressed extends SignupEvent {
  String name;
  String email;
  String password;
  BuildContext context;

  SignupButtonPressed({@required this.name ,@required this.email, @required this.password, @required this.context});
}
