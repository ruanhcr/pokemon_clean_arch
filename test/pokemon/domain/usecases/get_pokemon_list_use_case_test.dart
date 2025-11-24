import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon_clean_arch/core/errors/failure.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_entity.dart';
import 'package:pokemon_clean_arch/pokemon/domain/repositories/i_pokemon_repository.dart';
import 'package:pokemon_clean_arch/pokemon/domain/usecases/get_pokemon_list_use_case.dart';

class MockPokemonRepository extends Mock implements IPokemonRepository {}

void main() {
  late GetPokemonListUseCase useCase;
  late MockPokemonRepository repository;

  setUp(() {
    repository = MockPokemonRepository();
    useCase = GetPokemonListUseCase(repository: repository);
  });

  final tPokemonList = [
    PokemonEntity(id: 1, name: 'bulbasaur', imageUrl: 'img1'),
    PokemonEntity(id: 2, name: 'ivysaur', imageUrl: 'img2'),
  ];

  test(
    'Should return Right(List<PokemonEntity>) when the repository call is successful',
    () async {
      when(
        () => repository.getPokemonList(offset: any(named: 'offset')),
      ).thenAnswer((_) async => Right(tPokemonList));

      final result = await useCase(offset: 0);

      expect(result.isRight(), true);

      result.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r, tPokemonList),
      );

      verify(() => repository.getPokemonList(offset: 0)).called(1);
    },
  );

  test('Should return Left(Failure) when offset is negative', () async {
    final result = await useCase(offset: -1);
    expect(result.isLeft(), true);

    result.fold(
      (l) => expect(l, isA<Failure>()),
      (r) => fail('Should be Left'),
    );
    
    verifyNever(() => repository.getPokemonList(offset: any(named: 'offset')));
  });
}
