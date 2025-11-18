// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:injectable/injectable.dart';
import 'package:pokemon_clean_arch/modules/pokemon/domain/entities/pokemon_entity.dart';
import 'package:pokemon_clean_arch/modules/pokemon/domain/repositories/i_pokemon_repository.dart';

abstract class IGetPokemonUseCase {
  Future<PokemonEntity> call(String name);
}

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
