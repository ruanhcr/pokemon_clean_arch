import 'package:pokemon_clean_arch/modules/pokemon/domain/entities/pokemon_entity.dart';

abstract class IGetPokemonUseCase {
  Future<PokemonEntity> call(String name);
}