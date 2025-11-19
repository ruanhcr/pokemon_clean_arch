import 'package:pokemon_clean_arch/modules/pokemon/domain/entities/pokemon_entity.dart';

abstract class IGetPokemonListUseCase {
  Future<List<PokemonEntity>> call({int? offset, int? limit});
}