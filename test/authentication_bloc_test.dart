import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tcc_projeto_app/bloc/authentication_bloc.dart';
import 'package:tcc_projeto_app/repository/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository{}

void main(){

  AuthenticationBloc authenticationBloc;
  MockUserRepository userRepository;

  setUp((){
    userRepository = MockUserRepository();
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

      authenticationBloc.add(AppStarted());
    });

    test("When user is not null, should emit authenticated",(){
      final expectedState = [
        AuthenticationUninitialized(),
        AuthenticationAuthenticated()
      ];

      when(userRepository.getUser()).thenAnswer((_) => Future.value());
    });
  });
}