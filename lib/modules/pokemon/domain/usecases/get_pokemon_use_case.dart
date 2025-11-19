import 'package:injectable/injectable.dart';
import 'package:pokemon_clean_arch/modules/pokemon/domain/entities/pokemon_entity.dart';
import 'package:pokemon_clean_arch/modules/pokemon/domain/repositories/i_pokemon_repository.dart';
import 'package:pokemon_clean_arch/modules/pokemon/domain/usecases/i_get_pokemon_use_case.dart';

@Injectable(as: IGetPokemonUseCase)
class GetPokemonUseCase implements IGetPokemonUseCase {
  final IPokemonRepository repository;
  GetPokemonUseCase(this.repository);

  @override
  Future<PokemonEntity> call(String name) async {
    if (name.trim().isEmpty) {
      throw Exception("O nome do pokémon não pode ser vazio!");
    }
    return await repository.getPokemon(name.toLowerCase());
  }
}
