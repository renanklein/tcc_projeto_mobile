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
        super(null);

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginButtonPressed) {
      try {
        yield LoginProcessing();
        await this
            .userRepository
            .signIn(email: event.email, pass: event.password);

        final tokenResponse = await this.userRepository.getToken();
        this
            .authenticationBloc
            .add(LoggedIn(token: tokenResponse, context: event.context));

        UserDataUtils.setUserData(userRepository.getUser().uid);

        yield LoginSucceded();
      } catch (error, stack_trace) {
        await FirebaseCrashlytics.instance.recordError(error, stack_trace);
        yield LoginFailure();
      }
    } else if (event is LoginResetPasswordButtonPressed) {
      await this.userRepository.resetPassword(email: event.email);
      yield LoginPasswordReset();
    }
  }
}
