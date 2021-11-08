import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/login/models/user_model.dart';
import 'package:tcc_projeto_app/login/repositories/user_repository.dart';

class UserDataService{
  final UserRepository userRepository;
  final injector = Injector.appInstance;

  UserDataService({@required this.userRepository});

  Future setUserData(String userId) async{
    var userData = await userRepository.getUserData(userId);

    var user = UserModel.fromMap(userData.data(), userId);

    if (userId != null) {
      injector.registerSingleton<UserModel>(
        () => user,
        override: true,
      );
    }
  }
}