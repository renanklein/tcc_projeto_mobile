import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/pacient/models/base_view_model.dart';
import 'package:tcc_projeto_app/pacient/models/dialog_models.dart';
import 'package:tcc_projeto_app/pacient/models/pacient_model.dart';
import 'package:tcc_projeto_app/pacient/repositories/pacient_repository.dart';

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
