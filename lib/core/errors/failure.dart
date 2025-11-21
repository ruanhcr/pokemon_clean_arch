sealed class Failure implements Exception {
  final String message;

  Failure(this.message);
}

class DataParsingFailure extends Failure {
  DataParsingFailure([super.message = "Erro ao processar dados."]);
}

class NetworkFailure extends Failure {
  NetworkFailure([super.message = "Sem conexão com a internet."]);
}

class ServerFailure extends Failure {
  ServerFailure([super.message = "Ocorreu um erro no servidor."]);
}

class NotFoundFailure extends Failure {
  NotFoundFailure() : super("Pokémon não encontrado.");
}

class InvalidInputFailure extends Failure {
  InvalidInputFailure(super.message);
}

class EmptyInputFailure extends Failure {
  EmptyInputFailure(super.message);
}