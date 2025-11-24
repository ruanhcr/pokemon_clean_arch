import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:pokemon_clean_arch/core/errors/failure.dart';
import 'package:pokemon_clean_arch/pokemon/domain/repositories/i_pokemon_repository.dart';
import 'package:pokemon_clean_arch/pokemon/domain/usecases/i_remove_favorite_use_case.dart';

@Injectable(as: IRemoveFavoriteUseCase)
class RemoveFavoriteUseCase implements IRemoveFavoriteUseCase {
  final IPokemonRepository _repository;
  RemoveFavoriteUseCase({required IPokemonRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, void>> call(int id) async {
    return await _repository.removeFavorite(id);
  }
}
