import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tcc_projeto_app/login/blocs/authentication_bloc.dart';
import 'package:tcc_projeto_app/login/blocs/login_bloc.dart';
import 'package:tcc_projeto_app/login/repositories/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository{}
class MockAuthenticationBloc extends Mock implements AuthenticationBloc{}
class MockIdTokenResult extends Mock implements IdTokenResult{}
class MockBuildContext extends Mock implements BuildContext{}

void main(){

  MockUserRepository userRepository;
  MockAuthenticationBloc authenticationBloc;
  MockIdTokenResult fakeTokenResponse;
  MockBuildContext fakeContext;
  LoginBloc loginBloc;

  setUp((){
    userRepository = MockUserRepository();
    authenticationBloc = MockAuthenticationBloc();
    fakeTokenResponse = MockIdTokenResult();
    fakeContext = MockBuildContext();
    loginBloc = LoginBloc(
      userRepository: userRepository,
      authenticationBloc: authenticationBloc
    );
  });

  tearDown((){
    loginBloc.close();
  });

  test("When login bloc initilize, it's state should be initial", (){
    expect(loginBloc.initialState, LoginInitial());
  });

  group("LoginButtonPressed event",(){
    test("When event is LoginButtonPressed and no operation had failed, it should emit LoginSucceded", (){
      var expectedStates = [
        LoginInitial(),
        LoginProcessing(),
        LoginSucceded()
      ];

      expectLater(
        loginBloc,
        emitsInOrder(expectedStates)
      );

      loginBloc.add(LoginButtonPressed(
        context: fakeContext,
        email: "",
        password: ""
      ));
    });

    test("When event is LoginButtonPressed and any of external call fails, so i should emit LoginFailure", (){
      var expectedStates = [
        LoginInitial(),
        LoginProcessing(),
        LoginFailure()
      ];

      when(userRepository.signIn(email: "", pass: "")).thenThrow(Exception());

      expectLater(loginBloc, emitsInOrder(expectedStates));

      loginBloc.add(LoginButtonPressed(
        context: fakeContext,
        email: "",
        password: ""
      ));
    });
  });

  group("LoginResetPasswordButtonPressed event", (){
    test("When event is Reset Password and no external operation had failed, so it should emit LoginPasswordReset",(){
      var expectedStates = [
        LoginInitial(),
        LoginPasswordReset()
      ];

      expectLater(loginBloc, emitsInOrder(expectedStates));

      loginBloc.add(LoginResetPasswordButtonPressed(email: ""));
    });
  });  
}