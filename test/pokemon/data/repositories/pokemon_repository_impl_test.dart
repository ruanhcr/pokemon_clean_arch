import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon_clean_arch/core/errors/failure.dart';
import 'package:pokemon_clean_arch/pokemon/data/datasources/local/i_pokemon_local_data_source.dart';
import 'package:pokemon_clean_arch/pokemon/data/datasources/remote/i_pokemon_remote_data_source.dart';
import 'package:pokemon_clean_arch/pokemon/data/repositories/pokemon_repository_impl.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_entity.dart';

class MockRemoteDataSource extends Mock implements IPokemonRemoteDataSource {}

class MockLocalDataSource extends Mock implements IPokemonLocalDataSource {}

void main() {
  late PokemonRepositoryImpl repository;
  late MockRemoteDataSource remoteDataSource;
  late MockLocalDataSource localDataSource;

  setUp(() {
    remoteDataSource = MockRemoteDataSource();
    localDataSource = MockLocalDataSource();
    repository = PokemonRepositoryImpl(remoteDataSource, localDataSource);
  });

  final tJsonList = [
    {"name": "bulbasaur", "url": "https://pokeapi.co/api/v2/pokemon/1/"},
  ];

  group('PokemonRepositoryImpl', () {
    test(
      'Should return Right(List<PokemonEntity>) and parse ID correctly',
      () async {
        when(
          () => remoteDataSource.getPokemonList(offset: 0, limit: 20),
        ).thenAnswer((_) async => tJsonList);

        final result = await repository.getPokemonList(offset: 0);

        expect(result.isRight(), true);

        result.fold((failure) => fail('Should be Right'), (list) {
          expect(list, isNotEmpty);
          expect(list.first, isA<PokemonEntity>());
          expect(list.first.id, 1);
          expect(list.first.imageUrl, contains('/1.png'));
        });

        verify(
          () => remoteDataSource.getPokemonList(offset: 0, limit: 20),
        ).called(1);
      },
    );

    test(
      'Should return Left(Failure) when DataSource throws Exception',
      () async {
        when(
          () => remoteDataSource.getPokemonList(offset: any(named: 'offset')),
        ).thenThrow(Exception('API Error'));

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
