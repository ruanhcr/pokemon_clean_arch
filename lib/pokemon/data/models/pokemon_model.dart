import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_entity.dart';

class PokemonModel extends PokemonEntity {
  PokemonModel({
    required super.id,
    required super.name,
    required super.imageUrl,
  });

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    return PokemonModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      imageUrl: json['sprites']['front_default'] ?? '',
    );
  }

}