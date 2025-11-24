import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:pokemon_clean_arch/core/errors/failure.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_entity.dart';
import 'package:pokemon_clean_arch/pokemon/domain/repositories/i_pokemon_repository.dart';
import 'package:pokemon_clean_arch/pokemon/domain/usecases/i_get_favorites_use_case.dart';

@Injectable(as: IGetFavoritesUseCase)
class GetFavoritesUseCase implements IGetFavoritesUseCase {
  final IPokemonRepository _repository;
  GetFavoritesUseCase({required IPokemonRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<PokemonEntity>>> call() async {
    return await _repository.getFavorites();
  }
}
