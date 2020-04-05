import 'package:flutter/cupertino.dart';
import 'package:injector/injector.dart';
import 'package:tcc_projeto_app/pacient/models/base_view_model.dart';
import 'package:tcc_projeto_app/pacient/models/dialog_models.dart';
import 'package:tcc_projeto_app/pacient/models/pacient_model.dart';
import 'package:tcc_projeto_app/pacient/repositories/pacient_repository.dart';
import 'package:tcc_projeto_app/route_generator.dart';

class CreatePacientModel extends BaseViewModel {
  final _pacientRepository =
      Injector.appInstance.getDependency<PacientRepository>();

  final _routeGenerator = Injector.appInstance.getDependency<RouteGenerator>();

  Future createPacient({
    @required String nome,
    @required String email,
    @required String telefone,
    @required String identidade,
    @required String cpf,
    @required String dtNascimento,
    @required String sexo,
  }) async {
    setBusy(true);

    var result = await _pacientRepository.createPacient(
      pacient: PacientModel(
        userId: currentUser.uid,
        nome: nome,
        email: email,
        telefone: telefone,
        identidade: identidade,
        cpf: cpf,
        dtNascimento: dtNascimento,
        sexo: sexo,
      ),
    );

    setBusy(false);

    if (result is String) {
      ConfirmDialog(
        title: "Erro na inclusão de Paciente",
        description: 'result',
        buttonTitle: 'Voltar',
      );
    } else {
      ConfirmDialog(
        title: "Paciente Incluído",
        description: 'O paciente foi cadastrado com sucesso.',
        buttonTitle: 'Confirmar',
      );
    }

    _routeGenerator.pop();
  }
}
