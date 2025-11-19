import 'package:pokemon_clean_arch/modules/pokemon/domain/entities/pokemon_detail_entity.dart';

abstract interface class IGetPokemonDetailsUseCase {
  Future<PokemonDetailEntity> call(int id);
}
