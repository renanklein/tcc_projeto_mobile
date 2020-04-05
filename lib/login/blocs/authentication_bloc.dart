import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/login/repositories/user_repository.dart';


part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  UserRepository userRepository;
  String token;

  AuthenticationBloc({@required this.userRepository});

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if(event is AppStarted){
      final user = await this.userRepository.getUser();
       if(user == null){
         yield AuthenticationUnauthenticated();

         await this.userRepository.setupFcmNotification(user);
         await _configureNotificationsType(event.context);
         
       } else{
         yield AuthenticationAuthenticated();
       }
    }

    else if(event is LoggedIn){
      yield AuthenticationProcessing();
      
      final token = event.token;

      if(token == null || token.expirationTime.difference(DateTime.now()).inMilliseconds <= 0){
          yield AuthenticationUnauthenticated();
      }

      final user = await this.userRepository.getUser();
      await this.userRepository.setupFcmNotification(user);
      await _configureNotificationsType(event.context);

      yield AuthenticationAuthenticated();
    }

    else if(event is LoggedOut) {
       yield AuthenticationProcessing();
       await this.userRepository.logOut();
       yield AuthenticationUnauthenticated();
    }
  }

  Future<void> _configureNotificationsType(BuildContext context) async{
    var _fcm  = Injector.appInstance.getDependency<FirebaseMessaging>();
    _fcm.configure(
      onMessage:  (Map<String, dynamic> message) async{
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: message["notification"]["title"],
              subtitle: message["notification"]["subtitle"],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ],
          )
        );
      },
      onLaunch: (Map<String, dynamic> message) async{
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async{
        print("onResume: $message");
      }
    );

  }
}
