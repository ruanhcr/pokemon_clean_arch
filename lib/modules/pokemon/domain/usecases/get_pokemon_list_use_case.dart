import 'package:injectable/injectable.dart';
import 'package:pokemon_clean_arch/modules/pokemon/domain/entities/pokemon_entity.dart';
import 'package:pokemon_clean_arch/modules/pokemon/domain/repositories/i_pokemon_repository.dart';
import 'package:pokemon_clean_arch/modules/pokemon/domain/usecases/i_get_pokemon_list_use_case.dart';

@Injectable(as: IGetPokemonListUseCase)
class GetPokemonListUseCase implements IGetPokemonListUseCase {
  final IPokemonRepository repository;

  const GetPokemonListUseCase(this.repository);

  @override
  Future<List<PokemonEntity>> call({int? offset, int? limit}) async {
    if ((offset ?? 0) < 0) {
      throw Exception("Offset inválido: não pode ser negativo.");
    }
    return await repository.getPokemonList(offset: offset ?? 0);
  }
}