import 'package:flutter/widgets.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/model/user_model.dart';
import 'package:tcc_projeto_app/repository/user_repository.dart';

class BaseViewModel extends ChangeNotifier {
  final UserRepository _userRepository =
      Injector.appInstance.getDependency<UserRepository>();
  bool _busy = false;
  bool get busy => _busy;

  UserModel get currentUser => _userRepository.currentUser;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }
}
