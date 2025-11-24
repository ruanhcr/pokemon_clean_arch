import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon_clean_arch/pokemon/domain/repositories/i_pokemon_repository.dart';
import 'package:pokemon_clean_arch/pokemon/domain/usecases/is_favorite_use_case.dart';

class MockPokemonRepository extends Mock implements IPokemonRepository {}

void main() {
  late IsFavoriteUseCase useCase;
  late MockPokemonRepository repository;

  setUp(() {
    repository = MockPokemonRepository();
    useCase = IsFavoriteUseCase(repository: repository);
  });

  test('Should return true when pokemon is in favorites', () async {
    when(() => repository.isFavorite(1))
        .thenAnswer((_) async => const Right(true));

    final result = await useCase(1);

    expect(result, const Right(true));
    verify(() => repository.isFavorite(1)).called(1);
  });

  test('Should return false when pokemon is NOT in favorites', () async {
    when(() => repository.isFavorite(2))
        .thenAnswer((_) async => const Right(false));

    final result = await useCase(2);

    expect(result, const Right(false));
  });
}