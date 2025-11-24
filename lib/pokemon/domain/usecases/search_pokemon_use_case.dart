import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:pokemon_clean_arch/core/errors/failure.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_entity.dart';
import 'package:pokemon_clean_arch/pokemon/domain/repositories/i_pokemon_repository.dart';
import 'package:pokemon_clean_arch/pokemon/domain/usecases/i_search_pokemon_use_case.dart';

@Injectable(as: ISearchPokemonUseCase)
class SearchPokemonUseCase implements ISearchPokemonUseCase {
  final IPokemonRepository _repository;
  SearchPokemonUseCase({required IPokemonRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, PokemonEntity>> call(String name) async {
    if (name.trim().isEmpty) {
      return Left(EmptyInputFailure('Nome não pode ser vazio'));
    }

    return await _repository.searchPokemon(name);
  }
}
