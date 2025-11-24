import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:pokemon_clean_arch/core/helpers/string_constants.dart';
import 'package:pokemon_clean_arch/pokemon/data/datasources/local/i_pokemon_local_data_source.dart';
import 'package:pokemon_clean_arch/pokemon/data/models/pokemon_hive_model.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_entity.dart';

@Injectable(as: IPokemonLocalDataSource)
class PokemonLocalDataSourceImpl implements IPokemonLocalDataSource {
  final Box<PokemonHiveModel> _box;

  PokemonLocalDataSourceImpl(@Named(StringConstants.kHiveFavoritesBox) this._box);

  @override
  Future<void> saveFavorite(PokemonEntity pokemon) async {
    final hiveModel = PokemonHiveModel.fromEntity(pokemon);
    await _box.put(pokemon.id, hiveModel);
  }

  @override
  Future<void> removeFavorite(int id) async {
    await _box.delete(id);
  }

  @override
  Future<bool> isFavorite(int id) async {
    return _box.containsKey(id);
  }

  @override
  Future<List<PokemonEntity>> getFavorites() async {
    return _box.values.map((e) => e.toEntity()).toList();
  }
}
