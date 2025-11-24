
import 'package:hive/hive.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_entity.dart';
part 'pokemon_hive_model.g.dart';

@HiveType(typeId: 0)
class PokemonHiveModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String imageUrl;

  PokemonHiveModel({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  // Mappers para converter de/para Entity
  factory PokemonHiveModel.fromEntity(PokemonEntity entity) {
    return PokemonHiveModel(
      id: entity.id,
      name: entity.name,
      imageUrl: entity.imageUrl,
    );
  }

  PokemonEntity toEntity() {
    return PokemonEntity(
      id: id,
      name: name,
      imageUrl: imageUrl,
    );
  }
}