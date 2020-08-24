import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tcc_projeto_app/login/blocs/authentication_bloc.dart';
import 'package:tcc_projeto_app/login/blocs/signup_bloc.dart';
import 'package:tcc_projeto_app/login/repositories/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository{} 
class MockAuthenticationBloc extends Mock implements AuthenticationBloc{}
class MockBuildContext extends Mock implements BuildContext{}
class MockAuthResult extends Mock implements AuthResult{}
class MockFirebaseUser extends Mock implements FirebaseUser{}

void main(){
  MockUserRepository userRepository;
  MockAuthenticationBloc authenticationBloc;
  MockBuildContext fakeContext;
  MockAuthResult fakeAuthResult;
  MockFirebaseUser fakeUser;
  SignupBloc signupBloc;

  setUp((){
    userRepository = MockUserRepository();
    authenticationBloc = MockAuthenticationBloc();
    fakeContext = MockBuildContext();
    fakeAuthResult = MockAuthResult();

    fakeUser = MockFirebaseUser();
    signupBloc = SignupBloc(
      userRepository: userRepository,
      authenticationBloc: authenticationBloc
    );
  });

  tearDown((){
    authenticationBloc.close();
    signupBloc.close();
  });

  test("When bloc is initializing, it's states should be initial", (){
    expect(signupBloc.initialState, SignupInitial());
  });

  group("SignupButtonPressed event", (){
    test("When events is SignButtonPressed and no external call throwed an exception, it should emit SignupSigned", (){
      var expectedStates = [
        SignupInitial(),
        SignupProcessing(),
        SignupSigned()
      ];

      when(fakeAuthResult.user).thenReturn(fakeUser);
      when(userRepository.signUp(email: "", pass: "")).thenAnswer((_)=> Future.value(fakeAuthResult));
      when(userRepository.sendUserData(name: "", email: "", uid: ""));
      expectLater(signupBloc, emitsInOrder(expectedStates));

      signupBloc.add(SignupButtonPressed(
        email: "",
        name: "",
        password: "",
        context: fakeContext,
      ));
    });
    test("When events is SignButtonPressed and an exception was thrown, it should emit SignupFailed", (){
      var expectedStates = [
        SignupInitial(),
        SignupProcessing(),
        SignupFailed()
      ];

      expectLater(signupBloc, emitsInOrder(expectedStates));

      signupBloc.add(SignupButtonPressed(
        email: "",
        name: "",
        password: "",
        context: fakeContext,
      ));
    });
  });
}