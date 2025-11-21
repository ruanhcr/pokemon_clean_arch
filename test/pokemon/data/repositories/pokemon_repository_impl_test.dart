import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon_clean_arch/core/errors/failure.dart';
import 'package:pokemon_clean_arch/pokemon/data/datasources/i_pokemon_data_source.dart';
import 'package:pokemon_clean_arch/pokemon/data/repositories/pokemon_repository_impl.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_entity.dart';

class MockDataSource extends Mock implements IPokemonDataSource {}

void main() {
  late PokemonRepositoryImpl repository;
  late MockDataSource dataSource;

  setUp(() {
    dataSource = MockDataSource();
    repository = PokemonRepositoryImpl(dataSource);
  });

  final tJsonList = [
    {
      "name": "bulbasaur",
      "url": "https://pokeapi.co/api/v2/pokemon/1/"
    }
  ];

  group('PokemonRepositoryImpl', () {
    test(
      'Should return Right(List<PokemonEntity>) and parse ID correctly',
      () async {
        when(() => dataSource.getPokemonList(offset: 0, limit: 20))
            .thenAnswer((_) async => tJsonList);

        final result = await repository.getPokemonList(offset: 0);

        expect(result.isRight(), true);

        result.fold(
          (failure) => fail('Should be Right'),
          (list) {
            expect(list, isNotEmpty);
            expect(list.first, isA<PokemonEntity>());
            expect(list.first.id, 1);
            expect(list.first.imageUrl, contains('/1.png'));
          },
        );
        
        verify(() => dataSource.getPokemonList(offset: 0, limit: 20)).called(1);
      },
    );

    test(
      'Should return Left(Failure) when DataSource throws Exception',
      () async {
        when(() => dataSource.getPokemonList(offset: any(named: 'offset')))
            .thenThrow(Exception('API Error'));

        final result = await repository.getPokemonList(offset: 0);

        expect(result.isLeft(), true);
        
        result.fold(
          (failure) => expect(failure, isA<Failure>()),
          (r) => fail('Should be Left'),
        );
      },
    );
  });
}