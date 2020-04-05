import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tcc_projeto_app/login/blocs/authentication_bloc.dart';
import 'package:tcc_projeto_app/login/repositories/user_repository.dart';


class MockUserRepository extends Mock implements UserRepository{}
class MockBuildContext extends Mock implements BuildContext{}

void main(){

  AuthenticationBloc authenticationBloc;
  MockUserRepository userRepository;
  MockBuildContext context;

  setUp((){
    userRepository = MockUserRepository();
    context = MockBuildContext();
    authenticationBloc = AuthenticationBloc(userRepository: userRepository);
  });

  tearDown((){
    authenticationBloc.close();
  });

  test('When bloc initialize, state should be initial', (){
    expect(authenticationBloc.initialState, AuthenticationUninitialized());
  });

  test("When bloc closes, it does not emit new states",(){
    //arrange/assert
    expectLater(authenticationBloc, 
      emitsInOrder([AuthenticationUninitialized(), emitsDone])
    );

    //act
    authenticationBloc.close();
  });

  group("AppStarted", (){
    test("When user is null, should emit unauthenticated", (){
      //arrange
      final expectedStates = [
        AuthenticationUninitialized(),
        AuthenticationUnauthenticated(),
      ];

      when(userRepository.getUser()).thenAnswer((_) => Future.value(null));

      expectLater(authenticationBloc, 
        emitsInOrder(expectedStates));
      authenticationBloc.add(AppStarted(context: context));
    });

    test("When user is not null, but token is null, should emit unauthenticated",(){
      final expectedState = [
        AuthenticationProcessing(),
        AuthenticationUnauthenticated()
      ];

      when(userRepository.getUser()).thenAnswer((_) => Future.value());

      expectLater(
        authenticationBloc,
        emitsInOrder(expectedState)
      );
    });

    authenticationBloc.add(LoggedIn(token : null, context: context));
  });
}