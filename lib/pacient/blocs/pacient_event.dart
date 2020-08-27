part of 'pacient_bloc.dart';

abstract class PacientEvent extends Equatable {}

class PacientCreateButtonPressed extends PacientEvent {
  final userId;
  final nome;
  final email;
  final telefone;
  final identidade;
  final cpf;
  final dtNascimento;
  final sexo;

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

  @override
  List<Object> get props => throw UnimplementedError();
}

class PacientLoad extends PacientEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}

class PacientEditButtonPressed extends PacientEvent {
  final nome;
  final email;
  final telefone;
  final identidade;
  final cpf;
  final dtNascimento;
  final sexo;

  PacientEditButtonPressed({
    @required this.nome,
    @required this.email,
    @required this.telefone,
    @required this.identidade,
    @required this.cpf,
    @required this.dtNascimento,
    @required this.sexo,
  });

  @override
  List<Object> get props => throw UnimplementedError();
}

class PacientDeleteButtonPressed extends PacientEvent {
  final pacientId;

  PacientDeleteButtonPressed({
    @required this.pacientId,
  });

  @override
  List<Object> get props => throw UnimplementedError();
}