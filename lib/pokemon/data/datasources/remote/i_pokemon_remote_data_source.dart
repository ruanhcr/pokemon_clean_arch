abstract interface class IPokemonRemoteDataSource {
  Future<Map<String, dynamic>> searchPokemon(String name);
  Future<Map<String, dynamic>> getPokemonDetailById(int id);
  Future<List<Map<String, dynamic>>> getPokemonList({
    int offset = 0,
    int limit = 20,
  });
}
