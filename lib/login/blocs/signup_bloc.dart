import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/login/blocs/authentication_bloc.dart';
import 'package:tcc_projeto_app/login/repositories/user_repository.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  UserRepository userRepository;
  AuthenticationBloc authenticationBloc;

  SignupBloc(
      {@required this.userRepository,
      @required this.authenticationBloc});

  @override
  SignupState get initialState => SignupInitial();

  @override
  Stream<SignupState> mapEventToState(
    SignupEvent event,
  ) async* {
    if (event is SignupButtonPressed) {
      try {
        yield SignupProcessing();

        final signupResult = await this.userRepository.signUp(email: event.email, pass: event.password);
        await this.userRepository.sendUserData(
          name: event.name, 
          email: event.email, 
          uid: signupResult.user.uid
        );
        
        final token = await signupResult.user.getIdToken(); 
        
        this.authenticationBloc.add(LoggedIn(token: token, context: event.context));

        yield SignupSigned();

      } catch (error) {
        yield SignupFailed();
      }
    }
  }
}
