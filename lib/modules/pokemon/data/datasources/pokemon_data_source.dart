import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pokemon_clean_arch/modules/pokemon/data/datasources/i_pokemon_data_source.dart';

@Injectable(as: IPokemonDataSource)
class PokemonDataSource implements IPokemonDataSource {
  final Dio dio;

  PokemonDataSource(this.dio);

  @override
  Future<Map<String, dynamic>> getPokemonData(String name) async {
    try {
      final response = await dio.get('https://pokeapi.co/api/v2/pokemon/$name');
      return response.data;
    } on DioException catch (e) {
      throw Exception("Não foi possível achar o pokemon: ${e.message}");
    }
  }

  @override
  Future<Map<String, dynamic>> getPokemonDetailById(int id) async {
    try {
      final response = await dio.get('https://pokeapi.co/api/v2/pokemon/$id');
      return response.data;
    } on DioException catch (e) {
      throw Exception("Erro ao buscar detalhes do ID $id: ${e.message}");
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getPokemonList({
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      final response = await dio.get(
        'https://pokeapi.co/api/v2/pokemon',
        queryParameters: {'offset': offset, 'limit': limit},
      );

      return (response.data['results'] as List)
          .map((e) => e as Map<String, dynamic>)
          .toList();
    } on DioException catch (e) {
      throw Exception("Erro no DataSource: ${e.message}");
    }
  }
}
