import 'package:fpdart/fpdart.dart';
import 'package:pokemon_clean_arch/core/errors/failure.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_detail_entity.dart';

abstract class IGetPokemonDetailsUseCase {
  Future<Either<Failure, PokemonDetailEntity>> call(int id);
}
