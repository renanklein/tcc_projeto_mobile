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

  AuthenticationBloc({@required this.userRepository}) : super(null);

  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield AuthenticationProcessing();
      final user = this.userRepository.getUser();
      if (user == null) {
        yield AuthenticationUnauthenticated();
      } else {
        var token = await user.getIdTokenResult();
        if (token.expirationTime.isBefore(DateTime.now())) {
          this.userRepository.refreshToken();
        }
        await UserDataUtils.setUserData(this.userRepository.getUser().uid);
        await this.userRepository.setupFcmNotification(user);
        yield AuthenticationAuthenticated();
      }
    } else if (event is LoggedIn) {
      yield AuthenticationProcessing();
      final user = this.userRepository.getUser();
      await UserDataUtils.setUserData(this.userRepository.getUser().uid);
      await this.userRepository.setupFcmNotification(user);
      yield AuthenticationAuthenticated();
    } else if (event is LoggedOut) {
      yield AuthenticationProcessing();
      Injector.appInstance.removeByKey<UserModel>();
      await this.userRepository.logOut();
      yield AuthenticationUnauthenticated();
    }
  }
}
