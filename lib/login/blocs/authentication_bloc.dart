import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/login/models/user_model.dart';
import 'package:tcc_projeto_app/login/repositories/user_repository.dart';
import 'package:tcc_projeto_app/login/utils/userdata_utils.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  UserRepository userRepository;
  String token;

  AuthenticationBloc({@required this.userRepository}) : super(null){
    on<AppStarted>((event, emit) async{
       emit(AuthenticationProcessing());
      final user = this.userRepository.getUser();
      if (user == null) {
        emit(AuthenticationUnauthenticated());
      } else {
        var token = await user.getIdTokenResult();
        if (token.expirationTime.isBefore(DateTime.now())) {
          this.userRepository.refreshToken();
        }
        await UserDataUtils.setUserData(this.userRepository.getUser().uid);
        await this.userRepository.setupFcmNotification(user);
        emit(AuthenticationAuthenticated());
      }
    });

    on<LoggedIn>((event, emit) async {
      emit(AuthenticationProcessing());
      final user = this.userRepository.getUser();
      await UserDataUtils.setUserData(this.userRepository.getUser().uid);
      await this.userRepository.setupFcmNotification(user);
      emit(AuthenticationAuthenticated());
    });

    on<LoggedOut>((event, emit) async{
      emit(AuthenticationProcessing());

      Injector.appInstance.removeByKey<UserModel>();
      await this.userRepository.logOut();

      emit(AuthenticationUnauthenticated());
    });
  }

  AuthenticationState get initialState => AuthenticationUninitialized();
}
