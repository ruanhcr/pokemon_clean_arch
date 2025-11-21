
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_entity.dart';

class PokemonDetailEntity extends PokemonEntity {
  final int height;
  final int weight;
  final List<String> types; 
  final Map<String, int> stats;

  PokemonDetailEntity({
    required super.id,
    required super.name,
    required super.imageUrl,
    required this.height,
    required this.weight,
    required this.types,
    required this.stats,
  });
}