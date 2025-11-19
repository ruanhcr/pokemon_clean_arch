import 'package:injectable/injectable.dart';
import 'package:pokemon_clean_arch/modules/pokemon/domain/entities/pokemon_detail_entity.dart';
import 'package:pokemon_clean_arch/modules/pokemon/domain/repositories/i_pokemon_repository.dart';

import './i_get_pokemon_details_use_case.dart';

@Injectable(as: IGetPokemonDetailsUseCase)
class GetPokemonDetailsUseCase implements IGetPokemonDetailsUseCase {
  final IPokemonRepository repository;
  GetPokemonDetailsUseCase(this.repository);

  @override
  Future<PokemonDetailEntity> call(int id) async {
    if (id <= 0) {
      throw Exception(
        "ID inválido. O identificador do Pokémon deve ser positivo!",
      );
    }

    return await repository.getPokemonDetail(id);
  }
}
