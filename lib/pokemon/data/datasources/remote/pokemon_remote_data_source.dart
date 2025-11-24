import 'package:injectable/injectable.dart';
import 'package:pokemon_clean_arch/core/api/endpoints.dart';
import 'package:pokemon_clean_arch/core/network/rest_client/rest_client.dart';
import 'package:pokemon_clean_arch/pokemon/data/datasources/remote/i_pokemon_remote_data_source.dart';

@Injectable(as: IPokemonRemoteDataSource)
class PokemonRemoteDataSource implements IPokemonRemoteDataSource {
  final RestClient client;

  PokemonRemoteDataSource(this.client);

  @override
  Future<Map<String, dynamic>> searchPokemon(String name) async {
    final response = await client.get('${Endpoints.pokemon}/$name');
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> getPokemonDetailById(int id) async {
    final response = await client.get('${Endpoints.pokemon}/$id');
    return response.data;
  }

  @override
  Future<List<Map<String, dynamic>>> getPokemonList({
    int offset = 0,
    int limit = 20,
  }) async {
    final response = await client.get(
      Endpoints.pokemon,
      queryParameters: {'offset': offset, 'limit': limit},
    );

    return (response.data['results'] as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();
  }
}
