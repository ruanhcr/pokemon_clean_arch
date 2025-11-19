abstract interface class IPokemonDataSource {
  Future<Map<String, dynamic>> getPokemonData(String name);
  Future<Map<String, dynamic>> getPokemonDetailById(int id);
  Future<List<Map<String, dynamic>>> getPokemonList({int offset = 0, int limit = 20});
}