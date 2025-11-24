import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon_clean_arch/pokemon/data/datasources/local/pokemon_local_data_source_impl.dart';
import 'package:pokemon_clean_arch/pokemon/data/models/pokemon_hive_model.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_entity.dart';

class MockHiveBox extends Mock implements Box<PokemonHiveModel> {}

void main() {
  late PokemonLocalDataSourceImpl localDataSource;
  late MockHiveBox mockBox;

  setUp(() {
    mockBox = MockHiveBox();
    localDataSource = PokemonLocalDataSourceImpl(mockBox);

    registerFallbackValue(PokemonHiveModel(id: 0, name: '', imageUrl: ''));
  });

  final tPokemon = PokemonEntity(id: 1, name: 'Bulba', imageUrl: 'url');
  final tHiveModel = PokemonHiveModel.fromEntity(tPokemon);

  test('Should call box.put when saving a favorite', () async {
    when(() => mockBox.put(any(), any())).thenAnswer((_) async => {});

    await localDataSource.saveFavorite(tPokemon);

    verify(() => mockBox.put(1, any())).called(1);
  });

  test(
    'Should return list of PokemonEntity when getFavorites is called',
    () async {
      when(() => mockBox.values).thenReturn([tHiveModel]);

      final result = await localDataSource.getFavorites();

      expect(result.length, 1);
      expect(result.first.id, tPokemon.id);
    },
  );

  test('Should return true if box contains key', () async {
    when(() => mockBox.containsKey(1)).thenReturn(true);

    final result = await localDataSource.isFavorite(1);

    expect(result, true);
  });
}
