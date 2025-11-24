import 'package:pokemon_clean_arch/core/errors/failure.dart';

extension FailureMessage on Failure {
  String get uiMessage {
    return switch (this) {
      ServerFailure(message: var msg) => 'Servidor instável: $msg',
      NetworkFailure() => 'Sem conexão. Verifique sua rede.',
      DataParsingFailure() => 'Dados corrompidos.',
      NotFoundFailure() => 'Ops! Não encontramos nenhum Pokémon com esse nome.',
      InvalidInputFailure() => 'Ops! Parece que o ID do Pokémon é inválido',
      EmptyInputFailure() => 'O nome do Pokémon não pode ser vazio',
      CacheFailure() => 'Erro ao acessar favoritos',
    };
  }
}