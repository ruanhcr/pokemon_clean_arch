import 'package:fpdart/fpdart.dart';
import 'package:pokemon_clean_arch/core/errors/failure.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_entity.dart';

abstract class ISaveFavoriteUseCase {
  Future<Either<Failure, void>> call(PokemonEntity pokemon);
}
