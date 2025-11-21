import 'package:fpdart/fpdart.dart';
import 'package:pokemon_clean_arch/core/errors/failure.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_detail_entity.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_entity.dart';

abstract class IPokemonRepository {
  Future<Either<Failure, PokemonEntity>> searchPokemon(String name);
  Future<Either<Failure, PokemonDetailEntity>> getPokemonDetail(int id);
  Future<Either<Failure, List<PokemonEntity>>> getPokemonList({int offset = 0});
}
