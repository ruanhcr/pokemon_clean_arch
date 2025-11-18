import 'dart:convert';

import 'package:pokemon_clean_arch/modules/pokemon/domain/entities/pokemon_entity.dart';

class PokemonModel extends PokemonEntity {
  PokemonModel({
    required super.id,
    required super.name,
    required super.imageUrl,
  });

  factory PokemonModel.fromMap(Map<String, dynamic> map) {
    return PokemonModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      imageUrl: map['sprites']['front_default'] ?? '',
    );
  }

  factory PokemonModel.fromJson(String source) =>
      PokemonModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
