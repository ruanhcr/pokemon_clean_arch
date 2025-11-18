import 'package:pokemon_clean_arch/modules/pokemon/domain/entities/pokemon_entity.dart';

abstract class IPokemonRepository {
  Future<PokemonEntity> getPokemon(String name);
}
