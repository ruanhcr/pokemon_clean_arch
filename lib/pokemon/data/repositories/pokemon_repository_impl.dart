import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:pokemon_clean_arch/core/api/endpoints.dart';
import 'package:pokemon_clean_arch/core/errors/failure.dart';
import 'package:pokemon_clean_arch/core/utils/repository_runner.dart';
import 'package:pokemon_clean_arch/pokemon/data/datasources/i_pokemon_data_source.dart';
import 'package:pokemon_clean_arch/pokemon/data/models/pokemon_detail_model.dart';
import 'package:pokemon_clean_arch/pokemon/data/models/pokemon_model.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_detail_entity.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_entity.dart';
import 'package:pokemon_clean_arch/pokemon/domain/repositories/i_pokemon_repository.dart';

@Injectable(as: IPokemonRepository)
class PokemonRepositoryImpl implements IPokemonRepository {
  final IPokemonDataSource datasource;

  PokemonRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, PokemonEntity>> searchPokemon(String name) async {
    return runRepositorySafe(() async {
      final json = await datasource.searchPokemon(name);
      return PokemonModel.fromJson(json);
    });
  }

  @override
  Future<Either<Failure, PokemonDetailEntity>> getPokemonDetail(int id) async {
    return runRepositorySafe(() async {
      final json = await datasource.getPokemonDetailById(id);
      final pokemonModel = PokemonDetailModel.fromJson(json);
      return pokemonModel;
    });
  }

  @override
  Future<Either<Failure, List<PokemonEntity>>> getPokemonList({
    int offset = 0,
  }) async {
    return runRepositorySafe(() async {
      final listMap = await datasource.getPokemonList(offset: offset);

      return listMap.map((e) {
        final name = e['name'];
        final url = e['url'] as String;

        final uri = Uri.parse(url);
        final idStr = uri.pathSegments.lastWhere(
          (element) => element.isNotEmpty,
        );
        final id = int.parse(idStr);

        return PokemonEntity(
          id: id,
          name: name,
          imageUrl: Endpoints.imageUrl(id),
        );
      }).toList();
    });
  }
}
