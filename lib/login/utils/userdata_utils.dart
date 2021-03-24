import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/login/models/user_model.dart';
import 'package:tcc_projeto_app/login/repositories/user_repository.dart';

class UserDataUtils {
  static setUserData(String userId) async {
    var injector = Injector.appInstance;

    UserRepository userRepository = injector.get<UserRepository>();

    var userData = await userRepository.getUserData(userId);

    var user = UserModel.fromMap(userData.data(), userId);

    if (userId != null) {
      injector.registerSingleton<UserModel>(
        () => user,
        override: true,
        dependencyName: 'modeloId',
      );
    }
  }
}
