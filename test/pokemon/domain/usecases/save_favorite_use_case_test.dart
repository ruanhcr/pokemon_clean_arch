import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon_clean_arch/core/errors/failure.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_entity.dart';
import 'package:pokemon_clean_arch/pokemon/domain/repositories/i_pokemon_repository.dart';
import 'package:pokemon_clean_arch/pokemon/domain/usecases/save_favorite_use_case.dart';

class MockPokemonRepository extends Mock implements IPokemonRepository {}

void main() {
  late SaveFavoriteUseCase useCase;
  late MockPokemonRepository repository;

  setUp(() {
    repository = MockPokemonRepository();
    useCase = SaveFavoriteUseCase(repository: repository);
    registerFallbackValue(PokemonEntity(id: 0, name: '', imageUrl: ''));
  });

  final tPokemon = PokemonEntity(id: 1, name: 'Pikachu', imageUrl: 'url');

  test('Should call repository.saveFavorite and return Right(null)', () async {
    when(() => repository.saveFavorite(any()))
        .thenAnswer((_) async => const Right(null));

    final result = await useCase(tPokemon);

    expect(result.isRight(), true);
    verify(() => repository.saveFavorite(tPokemon)).called(1);
  });

  test('Should return Left(CacheFailure) when repository fails', () async {
    when(() => repository.saveFavorite(any()))
        .thenAnswer((_) async => Left(CacheFailure()));

    final result = await useCase(tPokemon);

    expect(result.isLeft(), true);
  });
}