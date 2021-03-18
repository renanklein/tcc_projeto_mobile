import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/login/blocs/authentication_bloc.dart';
import 'package:tcc_projeto_app/login/repositories/user_repository.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  UserRepository userRepository;
  AuthenticationBloc authenticationBloc;

  SignupBloc({@required this.userRepository, @required this.authenticationBloc})
      : super(null);

  @override
  SignupState get initialState => SignupInitial();

  @override
  Stream<SignupState> mapEventToState(
    SignupEvent event,
  ) async* {
    if (event is SignupButtonPressed) {
      try {
        yield SignupProcessing();

        final signupResult = await this
            .userRepository
            .signUp(email: event.email, pass: event.password);
        await this.userRepository.sendUserData(
              name: event.name,
              email: event.email,
              uid: signupResult.user.uid,
              medicId:
                  (event.access != 'MEDIC') ? userRepository.getUser().uid : '',
              access: event.access,
            );

        final token = await signupResult.user.getIdToken();

        this
            .authenticationBloc
            .add(LoggedIn(token: token, context: event.context));

        yield SignupSigned();
      } catch (error, stack_trace) {
        await FirebaseCrashlytics.instance.recordError(error, stack_trace);
        yield SignupFailed();
      }
    }
  }
}
