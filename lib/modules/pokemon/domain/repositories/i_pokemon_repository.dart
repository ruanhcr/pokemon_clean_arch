import 'package:pokemon_clean_arch/modules/pokemon/domain/entities/pokemon_detail_entity.dart';
import 'package:pokemon_clean_arch/modules/pokemon/domain/entities/pokemon_entity.dart';

abstract class IPokemonRepository {
  Future<PokemonEntity> getPokemon(String name);
  Future<PokemonDetailEntity> getPokemonDetail(int id);
  Future<List<PokemonEntity>> getPokemonList({int offset = 0});
}
