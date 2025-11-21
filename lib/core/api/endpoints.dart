class Endpoints {
  Endpoints._();

  static const String baseUrl = 'https://pokeapi.co/api/v2';

  static const String pokemon = '$baseUrl/pokemon';
  
  static String imageUrl(int id) => 
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
}