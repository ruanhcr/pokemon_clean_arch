import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:pokemon_clean_arch/core/errors/failure.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_entity.dart';
import 'package:pokemon_clean_arch/pokemon/domain/repositories/i_pokemon_repository.dart';
import 'package:pokemon_clean_arch/pokemon/domain/usecases/i_get_pokemon_list_use_case.dart';

@Injectable(as: IGetPokemonListUseCase)
class GetPokemonListUseCase implements IGetPokemonListUseCase {
  final IPokemonRepository repository;

  const GetPokemonListUseCase(this.repository);

  @override
  Future<Either<Failure, List<PokemonEntity>>> call({
    int? offset,
    int? limit,
  }) async {
    if ((offset ?? 0) < 0) {
      return Left(
        DataParsingFailure('Offset inválido: não pode ser negativo.'),
      );
    }
    return await repository.getPokemonList(offset: offset ?? 0);
  }
}