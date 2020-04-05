part of 'pacient_bloc.dart';

abstract class PacientEvent extends Equatable {}

class PacientCreateButtonPressed extends PacientEvent {
  String userId;
  String nome;
  String email;
  String telefone;
  String identidade;
  String cpf;
  String dtNascimento;
  String sexo;

  PacientCreateButtonPressed({
    @required this.userId,
    @required this.nome,
    @required this.email,
    @required this.telefone,
    @required this.identidade,
    @required this.cpf,
    @required this.dtNascimento,
    @required this.sexo,
  });
}

class PacientLoad extends PacientEvent {}

class PacientEditButtonPressed extends PacientEvent {
  String nome;
  String email;
  String telefone;
  String identidade;
  String cpf;
  String dtNascimento;
  String sexo;

  PacientEditButtonPressed({
    @required this.nome,
    @required this.email,
    @required this.telefone,
    @required this.identidade,
    @required this.cpf,
    @required this.dtNascimento,
    @required this.sexo,
  });
}

class PacientDeleteButtonPressed extends PacientEvent {
  String pacientId;

  PacientDeleteButtonPressed({
    @required this.pacientId,
  });
}
