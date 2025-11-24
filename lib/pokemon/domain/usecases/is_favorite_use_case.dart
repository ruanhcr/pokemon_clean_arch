import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:pokemon_clean_arch/core/errors/failure.dart';
import 'package:pokemon_clean_arch/pokemon/domain/repositories/i_pokemon_repository.dart';
import 'package:pokemon_clean_arch/pokemon/domain/usecases/i_is_favorite_use_case.dart';

@Injectable(as: IIsFavoriteUseCase)
class IsFavoriteUseCase implements IIsFavoriteUseCase {
  final IPokemonRepository _repository;
  IsFavoriteUseCase({required IPokemonRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, bool>> call(int id) async {
    return await _repository.isFavorite(id);
  }
}
