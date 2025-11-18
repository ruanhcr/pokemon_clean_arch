// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:injectable/injectable.dart';
import 'package:pokemon_clean_arch/modules/pokemon/data/datasources/pokemon_data_source.dart';
import 'package:pokemon_clean_arch/modules/pokemon/data/models/pokemon_model.dart';
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
}
