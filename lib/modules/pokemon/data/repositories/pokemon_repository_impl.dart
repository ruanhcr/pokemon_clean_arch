import 'package:injectable/injectable.dart';
import 'package:pokemon_clean_arch/modules/pokemon/data/datasources/i_pokemon_data_source.dart';
import 'package:pokemon_clean_arch/modules/pokemon/data/models/pokemon_detail_model.dart';
import 'package:pokemon_clean_arch/modules/pokemon/data/models/pokemon_model.dart';
import 'package:pokemon_clean_arch/modules/pokemon/domain/entities/pokemon_detail_entity.dart';
import 'package:pokemon_clean_arch/modules/pokemon/domain/entities/pokemon_entity.dart';
import 'package:pokemon_clean_arch/modules/pokemon/domain/repositories/i_pokemon_repository.dart';

@Injectable(as: IPokemonRepository)
class PokemonRepositoryImpl implements IPokemonRepository {
  final IPokemonDataSource datasource;

  PokemonRepositoryImpl(this.datasource);

  @override
  Future<PokemonEntity> getPokemon(String name) async {
    final json = await datasource.getPokemonData(name);
    final pokemonModel = PokemonModel.fromMap(json);
    return pokemonModel;
  }
  
  @override
  Future<PokemonDetailEntity> getPokemonDetail(int id) async {
    final json = await datasource.getPokemonDetailById(id);
    final pokemonModel = PokemonDetailModel.fromJson(json);
    return pokemonModel;
  }

  @override
  Future<List<PokemonEntity>> getPokemonList({int offset = 0}) async {
    final listMap = await datasource.getPokemonList(offset: offset);
    
    return listMap.map((e) {
      final name = e['name'];
      final url = e['url'] as String;
      
      final uri = Uri.parse(url);
      final idStr = uri.pathSegments.lastWhere((element) => element.isNotEmpty);
      final id = int.parse(idStr);

      return PokemonEntity(
        id: id,
        name: name,
        imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png',
      );
    }).toList();
  }
}
