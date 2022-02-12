import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/login/blocs/authentication_bloc.dart';
import 'package:tcc_projeto_app/login/repositories/user_repository.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:tcc_projeto_app/login/utils/userdata_utils.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  @override
  LoginState get initialState => LoginInitial();
  UserRepository userRepository;
  AuthenticationBloc authenticationBloc;

  LoginBloc({@required this.userRepository, @required this.authenticationBloc})
      : assert(userRepository != null && authenticationBloc != null),
        super(null) {
    on<LoginButtonPressed>((event, emit) async {
      try {
        emit(LoginProcessing());
        var credentials = await this
            .userRepository
            .signIn(email: event.email, pass: event.password);

        var token = await credentials.user.getIdTokenResult();

        if (token.expirationTime.isBefore(DateTime.now())) {
          await this.userRepository.refreshToken();
        }
        await UserDataUtils.setUserData(this.userRepository.getUser().uid);

        emit(LoginSucceded());
      } catch (error, stack_trace) {
        await FirebaseCrashlytics.instance.recordError(error, stack_trace);
        emit(LoginFailure());
      }
    });

    on<LoginResetPasswordButtonPressed>((event, emit) async {
      await this.userRepository.resetPassword(email: event.email);
      emit(LoginPasswordReset());
    });
  }
}
