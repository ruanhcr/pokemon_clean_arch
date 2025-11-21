import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_detail_entity.dart';

class PokemonDetailModel extends PokemonDetailEntity {
  PokemonDetailModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.height,
    required super.weight,
    required super.types,
    required super.stats,
  });

  factory PokemonDetailModel.fromJson(Map<String, dynamic> json) {
    final statsMap = <String, int>{};
    for (var item in (json['stats'] as List)) {
      statsMap[item['stat']['name']] = item['base_stat'];
    }

    final typesList = (json['types'] as List)
        .map((t) => t['type']['name'] as String)
        .toList();

    return PokemonDetailModel(
      id: json['id'],
      name: json['name'],
      imageUrl:
          json['sprites']['other']['official-artwork']['front_default'] ??
          json['sprites']['front_default'],
      height: json['height'],
      weight: json['weight'],
      types: typesList,
      stats: statsMap,
    );
  }
}
