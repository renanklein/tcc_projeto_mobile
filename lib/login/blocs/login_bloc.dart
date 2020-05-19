import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/login/blocs/authentication_bloc.dart';
import 'package:tcc_projeto_app/login/repositories/user_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  @override
  LoginState get initialState => LoginInitial();
  UserRepository userRepository;
  AuthenticationBloc authenticationBloc;

  LoginBloc({@required this.userRepository, @required this.authenticationBloc})
    : assert(userRepository != null && authenticationBloc != null);

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if(event is LoginButtonPressed){
      try{
        yield LoginProcessing();
        await this.userRepository.signIn(email: event.email, pass: event.password);
        
        final tokenResponse = await this.userRepository.getToken();
        this.authenticationBloc.add(LoggedIn(token: tokenResponse, context: event.context));
        yield LoginSucceded();
      }
      catch(error){
        yield LoginFailure();
      }
    }
    else if (event is LoginResetPasswordButtonPressed){
      await this.userRepository.resetPassword(email: event.email);
      yield LoginPasswordReset();
    }
  }
}
