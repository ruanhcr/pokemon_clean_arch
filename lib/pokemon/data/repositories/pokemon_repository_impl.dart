import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:pokemon_clean_arch/core/api/endpoints.dart';
import 'package:pokemon_clean_arch/core/errors/failure.dart';
import 'package:pokemon_clean_arch/core/utils/repository_runner.dart';
import 'package:pokemon_clean_arch/pokemon/data/datasources/local/i_pokemon_local_data_source.dart';
import 'package:pokemon_clean_arch/pokemon/data/datasources/remote/i_pokemon_remote_data_source.dart';
import 'package:pokemon_clean_arch/pokemon/data/models/pokemon_detail_model.dart';
import 'package:pokemon_clean_arch/pokemon/data/models/pokemon_model.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_detail_entity.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_entity.dart';
import 'package:pokemon_clean_arch/pokemon/domain/repositories/i_pokemon_repository.dart';

@Injectable(as: IPokemonRepository)
class PokemonRepositoryImpl implements IPokemonRepository {
  final IPokemonRemoteDataSource remoteDataSource;
  final IPokemonLocalDataSource localDataSource;

  PokemonRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Either<Failure, PokemonEntity>> searchPokemon(String name) async {
    return runRepositorySafe(() async {
      final json = await remoteDataSource.searchPokemon(name);
      return PokemonModel.fromJson(json);
    });
  }

  @override
  Future<Either<Failure, PokemonDetailEntity>> getPokemonDetail(int id) async {
    return runRepositorySafe(() async {
      final json = await remoteDataSource.getPokemonDetailById(id);
      final pokemonModel = PokemonDetailModel.fromJson(json);
      return pokemonModel;
    });
  }

  @override
  Future<Either<Failure, List<PokemonEntity>>> getPokemonList({
    int offset = 0,
  }) async {
    return runRepositorySafe(() async {
      final listMap = await remoteDataSource.getPokemonList(offset: offset);

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

  @override
  Future<Either<Failure, void>> saveFavorite(PokemonEntity pokemon) async {
    try {
      await localDataSource.saveFavorite(pokemon);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> removeFavorite(int id) async {
    try {
      await localDataSource.removeFavorite(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(int id) async {
    try {
      final result = await localDataSource.isFavorite(id);
      return Right(result);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<PokemonEntity>>> getFavorites() async {
    try {
      final result = await localDataSource.getFavorites();
      return Right(result);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
