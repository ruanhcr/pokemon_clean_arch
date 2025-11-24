import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_detail_entity.dart';
import 'package:pokemon_clean_arch/pokemon/domain/repositories/i_pokemon_repository.dart';
import 'package:pokemon_clean_arch/pokemon/domain/usecases/get_pokemon_details_use_case.dart';

class MockPokemonRepository extends Mock implements IPokemonRepository {}

void main() {
  late GetPokemonDetailsUseCase useCase;
  late MockPokemonRepository repository;

  setUp(() {
    repository = MockPokemonRepository();
    useCase = GetPokemonDetailsUseCase(repository: repository);
  });

  final tPokemonDetails = PokemonDetailEntity(
    id: 1,
    name: 'Bulbasaur',
    imageUrl: 'img1',
    height: 100,
    weight: 200,
    types: ['Venom'],
    stats: {'hp': 45, 'attack': 49, 'defense': 49, 'speed': 45},
  );

test(
    'Should return Right(PokemonDetailEntity) when the repository call is successful',
    () async {
      when(() => repository.getPokemonDetail(1))
          .thenAnswer((_) async => Right(tPokemonDetails));

      final result = await useCase(1);

      expect(result.isRight(), true);
      
      result.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r, tPokemonDetails),
      );

      verify(() => repository.getPokemonDetail(1)).called(1);
    },
  );

  test(
    'Should return Left(Failure) when the id is zero or negative',
    () async {
      final resultZero = await useCase(0);
      final resultNegative = await useCase(-1);
      
      expect(resultZero.isLeft(), true);
      expect(resultNegative.isLeft(), true);

      verifyNever(() => repository.getPokemonDetail(any()));
    },
  );
}
