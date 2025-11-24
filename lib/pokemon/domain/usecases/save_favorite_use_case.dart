import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:pokemon_clean_arch/core/errors/failure.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_entity.dart';
import 'package:pokemon_clean_arch/pokemon/domain/repositories/i_pokemon_repository.dart';
import 'package:pokemon_clean_arch/pokemon/domain/usecases/i_save_favorite_use_case.dart';

@Injectable(as: ISaveFavoriteUseCase)
class SaveFavoriteUseCase implements ISaveFavoriteUseCase {
  final IPokemonRepository _repository;
  SaveFavoriteUseCase({required IPokemonRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, void>> call(PokemonEntity pokemon) async {
    return await _repository.saveFavorite(pokemon);
  }
}
