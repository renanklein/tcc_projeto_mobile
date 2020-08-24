part of 'signup_bloc.dart';

abstract class SignupState extends Equatable {}

class SignupInitial extends SignupState {
  @override
  List<Object> get props => [];
}

class SignupUnsigned extends SignupState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class SignupProcessing extends SignupState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class SignupSigned extends SignupState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class SignupFailed extends SignupState {
  @override
  List<Object> get props => throw UnimplementedError();
}
