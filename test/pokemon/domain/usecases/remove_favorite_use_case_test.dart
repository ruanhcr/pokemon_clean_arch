import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon_clean_arch/pokemon/domain/repositories/i_pokemon_repository.dart';
import 'package:pokemon_clean_arch/pokemon/domain/usecases/remove_favorite_use_case.dart';

class MockPokemonRepository extends Mock implements IPokemonRepository {}

void main() {
  late RemoveFavoriteUseCase useCase;
  late MockPokemonRepository repository;

  setUp(() {
    repository = MockPokemonRepository();
    useCase = RemoveFavoriteUseCase(repository: repository);
  });

  test('Should call repository.removeFavorite and return Right(null)', () async {
    when(() => repository.removeFavorite(any()))
        .thenAnswer((_) async => const Right(null));

    final result = await useCase(1);

    expect(result.isRight(), true);
    verify(() => repository.removeFavorite(1)).called(1);
  });
}