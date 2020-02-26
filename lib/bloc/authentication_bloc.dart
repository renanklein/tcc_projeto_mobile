import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:tcc_projeto_app/repository/user_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  UserRepository userRepository;
  String token;

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  AuthenticationBloc({@required this.userRepository}) : assert(userRepository != null);

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
      
      final token = event.token;

      if(token == null || token.expirationTime.difference(DateTime.now()).inMilliseconds <= 0){
          yield AuthenticationUnauthenticated();
      }

      yield AuthenticationAuthenticated();
    }

    else if(event is LoggedOut) {
       yield AuthenticationProcessing();
       this.userRepository.logOut();
       yield AuthenticationUnauthenticated();
    }
  }
}