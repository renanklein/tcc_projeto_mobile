import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/model/base_view_model.dart';
import 'package:tcc_projeto_app/model/dialog_models.dart';
import 'package:tcc_projeto_app/model/pacient_model.dart';
import 'package:tcc_projeto_app/repository/pacient_repository.dart';
import 'package:tcc_projeto_app/repository/user_repository.dart';

class ListPacientModel extends BaseViewModel {
  final PacientRepository _userRepository =
      Injector.appInstance.getDependency<PacientRepository>();

  PacientRepository _pacientRepository;

  List<PacientModel> _pacients;
  List<PacientModel> get pacients => _pacients;

  Future fetchPacients() async {
    var pacientsResults = await _pacientRepository.getPacientsList();

    if (pacientsResults is List<PacientModel>) {
      _pacients = pacientsResults;
    } else {
      await ConfirmDialog(
          title: 'Erro',
          description: 'Erro ao listar pacientes. Tente Novamente.',
          buttonTitle: 'Confirmar');
    }
  }
}
