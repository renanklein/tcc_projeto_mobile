import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tcc_projeto_app/login/blocs/authentication_bloc.dart';
import 'package:tcc_projeto_app/login/repositories/user_repository.dart';


class MockUserRepository extends Mock implements UserRepository{}
class MockBuildContext extends Mock implements BuildContext{}
class MockFirebaseUser extends Mock implements FirebaseUser{}
class MockIdTokenResult extends Mock implements IdTokenResult{}


void main(){

  AuthenticationBloc authenticationBloc;
  MockUserRepository userRepository;
  MockFirebaseUser userResponse;
  MockIdTokenResult tokenResult;
  MockBuildContext context;

  setUp((){
    userRepository = MockUserRepository();
    context = MockBuildContext();
    userResponse = MockFirebaseUser();
    tokenResult = MockIdTokenResult();
    authenticationBloc = AuthenticationBloc(userRepository: userRepository);
  });

  tearDown((){
    authenticationBloc.close();
  });

  test('When bloc initialize, state should be initial', (){
    expect(authenticationBloc.initialState, AuthenticationUninitialized());
  });

  group("AppStarted", (){
    test("When user is null, should emit unauthenticated", (){
      //arrange
      final expectedStates = [
        AuthenticationUninitialized(),
        AuthenticationUnauthenticated(),
      ];
      when(userRepository.getUser()).thenAnswer((_) => Future.value(null));

      expectLater(
        authenticationBloc, 
        emitsInOrder(expectedStates)
      );

      authenticationBloc.add(AppStarted(context: context));
    });

    test("When user is not null, should emit authenticated", (){
      final expectedStates = [
        AuthenticationUninitialized(),
        AuthenticationAuthenticated()
      ];

      when(userRepository.getUser()).thenAnswer((_) => Future.value(userResponse));

      expectLater(authenticationBloc, emitsInOrder(expectedStates));

      authenticationBloc.add(AppStarted(context: context));
    });
  });

  group("LoggedIn", (){
    test("When token is null, should emit unauthenticated", (){
      var expectedStates = [
        AuthenticationUninitialized(),
        AuthenticationProcessing(),
        AuthenticationUnauthenticated()
      ];

      expectLater(
        authenticationBloc,
        emitsInOrder(expectedStates)
      );

      authenticationBloc.add(LoggedIn(token: null, context: context));
    });

    test("When token is expired, should emit unauthenticated", (){
      var expectedStates = [
        AuthenticationUninitialized(),
        AuthenticationProcessing(),
        AuthenticationUnauthenticated()
      ];

      when(tokenResult.expirationTime).thenReturn(DateTime(2019,01,13));

      expectLater(
        authenticationBloc,
        emitsInOrder(expectedStates)
      );

      authenticationBloc.add(LoggedIn(token: tokenResult, context: context));
    });

    test("When token is OK, should emit authenticated", (){
      var expectedStates = [
        AuthenticationUninitialized(),
        AuthenticationProcessing(),
        AuthenticationAuthenticated()
      ];

      when(tokenResult.expirationTime).thenReturn(DateTime(2021, 09, 09));

      expectLater(
        authenticationBloc, 
        emitsInOrder(expectedStates)
      );

      authenticationBloc.add(LoggedIn(token : tokenResult, context: context));
    });
  });

  group("LoggedOut", (){
    test("When log out is called, should emit Unauthenticated",(){
      var expectedStates = [
        AuthenticationUninitialized(),
        AuthenticationProcessing(),
        AuthenticationUnauthenticated()
      ];

      expectLater(authenticationBloc, emitsInOrder(expectedStates));

      authenticationBloc.add(LoggedOut());
    });
  });
}
