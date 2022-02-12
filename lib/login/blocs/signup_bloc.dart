import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/login/blocs/authentication_bloc.dart';
import 'package:tcc_projeto_app/login/repositories/user_repository.dart';
import 'package:tcc_projeto_app/login/utils/userdata_utils.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  UserRepository userRepository;
  AuthenticationBloc authenticationBloc;

  SignupBloc({@required this.userRepository, @required this.authenticationBloc})
      : super(null) {
    on<SignupButtonPressed>((event, emit) async {
      try {
        emit(SignupProcessing());

        final userId = this.userRepository.getUser()?.uid;

        final signupResult = await this
            .userRepository
            .signUp(email: event.email, pass: event.password);

        await this.userRepository.sendUserData(
              name: event.name,
              email: event.email,
              uid: signupResult.user.uid,
              medicId:
                  (event.access != 'MEDIC' && userId != null) ? userId : '',
              access: event.access,
            );

        if (userId == null) {
          final token = await signupResult.user.getIdToken();

          this.authenticationBloc.add(
                LoggedIn(token: token, context: event.context),
              );

          UserDataUtils.setUserData(signupResult.user.uid);
        }

        emit(SignupSigned());
      } catch (error, stack_trace) {
        await FirebaseCrashlytics.instance.recordError(error, stack_trace);
        emit(SignupFailed());
      }
    });
  }
}
