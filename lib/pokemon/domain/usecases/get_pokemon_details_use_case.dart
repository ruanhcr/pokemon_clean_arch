import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:pokemon_clean_arch/core/errors/failure.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_detail_entity.dart';
import 'package:pokemon_clean_arch/pokemon/domain/repositories/i_pokemon_repository.dart';

import 'i_get_pokemon_details_use_case.dart';

@Injectable(as: IGetPokemonDetailsUseCase)
class GetPokemonDetailsUseCase implements IGetPokemonDetailsUseCase {
  final IPokemonRepository repository;
  GetPokemonDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, PokemonDetailEntity>> call(int id) async {
    if (id <= 0) {
      return Left(
        InvalidInputFailure(
          'ID inválido. O identificador do Pokémon deve ser positivo!',
        ),
      );
    }

    return await repository.getPokemonDetail(id);
  }
}
