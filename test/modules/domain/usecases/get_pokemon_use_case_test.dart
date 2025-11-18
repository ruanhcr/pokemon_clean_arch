import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon_clean_arch/modules/pokemon/domain/entities/pokemon_entity.dart';
import 'package:pokemon_clean_arch/modules/pokemon/domain/repositories/i_pokemon_repository.dart';
import 'package:pokemon_clean_arch/modules/pokemon/domain/usecases/get_pokemon_use_case.dart';

class MockPokemonRepository extends Mock implements IPokemonRepository {}

void main() {
  late GetPokemonUseCase useCase;
  late MockPokemonRepository repository;

  setUp(() {
    repository = MockPokemonRepository();
    useCase = GetPokemonUseCase(repository);
  });

  final tPokemon = PokemonEntity(id: 1, name: 'pikachu', imageUrl: 'url');

  test('Should return a PokemonEntity when the repository call is successful', () async {
    when(() => repository.getPokemon(any())).thenAnswer((_) async => tPokemon);

    final result = await useCase('pikachu');

    expect(result, isA<PokemonEntity>());
    expect(result.name, 'pikachu');
    
    verify(() => repository.getPokemon('pikachu')).called(1);
  });

  test('Should throw an exception when the name is empty', () async {
    expect(() => useCase(''), throwsException);
    verifyNever(() => repository.getPokemon(any()));
  });
}