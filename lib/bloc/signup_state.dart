part of 'signup_bloc.dart';

abstract class SignupState extends Equatable {

}

class SignupInitial extends SignupState {
  @override
  List<Object> get props => [];
}

class SignupUnsigned extends SignupState{}

class SignupProcessing extends SignupState{}

class SignupSigned extends SignupState{}

class SignupFailed extends SignupState{}
