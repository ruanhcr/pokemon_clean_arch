import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_entity.dart';
import 'package:pokemon_clean_arch/pokemon/domain/repositories/i_pokemon_repository.dart';
import 'package:pokemon_clean_arch/pokemon/domain/usecases/get_favorites_use_case.dart';

class MockPokemonRepository extends Mock implements IPokemonRepository {}

void main() {
  late GetFavoritesUseCase useCase;
  late MockPokemonRepository repository;

  setUp(() {
    repository = MockPokemonRepository();
    useCase = GetFavoritesUseCase(repository: repository);
  });

  final tPokemon = PokemonEntity(id: 1, name: 'Pikachu', imageUrl: 'url');

  test('Should return a list of PokemonEntity from repository', () async {
    final tList = [tPokemon];
    when(() => repository.getFavorites())
        .thenAnswer((_) async => Right(tList));

    final result = await useCase();

    expect(result.isRight(), true);
    result.fold(
      (l) => fail('Should be Right'),
      (r) => expect(r, tList),
    );
    verify(() => repository.getFavorites()).called(1);
  });
}