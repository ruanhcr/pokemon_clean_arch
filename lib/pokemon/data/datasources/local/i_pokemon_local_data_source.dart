import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_entity.dart';

abstract class IPokemonLocalDataSource {
  Future<void> saveFavorite(PokemonEntity pokemon);
  Future<void> removeFavorite(int id);
  Future<bool> isFavorite(int id);
  Future<List<PokemonEntity>> getFavorites();
}
