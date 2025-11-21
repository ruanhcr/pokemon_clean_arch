import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon_clean_arch/core/errors/failure.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_entity.dart';
import 'package:pokemon_clean_arch/pokemon/domain/repositories/i_pokemon_repository.dart';
import 'package:pokemon_clean_arch/pokemon/domain/usecases/search_pokemon_use_case.dart';

class MockPokemonRepository extends Mock implements IPokemonRepository {}

void main() {
  late SearchPokemonUseCase useCase;
  late MockPokemonRepository repository;

  setUp(() {
    repository = MockPokemonRepository();
    useCase = SearchPokemonUseCase(repository);
  });

  final tPokemon = PokemonEntity(id: 1, name: 'pikachu', imageUrl: 'url');

  test(
    'Should return a Right(PokemonEntity) when the repository call is successful',
    () async {
      when(
        () => repository.searchPokemon(any()),
      ).thenAnswer((_) async => Right(tPokemon));

      final result = await useCase('pikachu');

      expect(result.isRight(), true);

      result.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r, tPokemon),
      );

      verify(() => repository.searchPokemon('pikachu')).called(1);
    },
  );

test('Should return Left(EmptyInputFailure) when the name is empty', () async {
    final result = await useCase('');
    expect(result.isLeft(), true);
    
    result.fold(
      (l) => expect(l, isA<EmptyInputFailure>()), 
      (r) => fail('Should be Left'),
    );

    verifyNever(() => repository.searchPokemon(any()));
  });
}
