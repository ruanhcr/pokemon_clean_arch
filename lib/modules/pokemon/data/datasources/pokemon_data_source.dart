import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract interface class IPokemonDataSource {
  Future<Map<String, dynamic>> getPokemonData(String name);
}

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
}
