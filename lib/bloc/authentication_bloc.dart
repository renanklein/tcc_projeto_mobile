import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:tcc_projeto_app/repository/user_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  UserRepository userRepository;
  String email;
  String password;

  @override
  AuthenticationState get initialState => AuthenticationInitial();

  AuthenticationBloc({@required this.userRepository});

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {

    if(event is AppStarted){
      final user = await this.userRepository.getUser();
       if(user == null){
         yield AuthenticationUnauthenticated();
       } else{
         yield AuthenticationAuthenticated();
       }
    }

    else if(event is LoggedIn){
      yield AuthenticationProcessing();
      this.userRepository.signIn(
        email: email, 
        pass: password);
      yield AuthenticationAuthenticated();
    }

    else if(event is LoggedOut) {
       yield AuthenticationProcessing();
       this.userRepository.logOut();
       yield AuthenticationUnauthenticated();
    }
  }
}
