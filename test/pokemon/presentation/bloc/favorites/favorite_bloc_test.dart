import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon_clean_arch/core/log/app_logger.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_entity.dart';
import 'package:pokemon_clean_arch/pokemon/domain/usecases/i_get_favorites_use_case.dart';
import 'package:pokemon_clean_arch/pokemon/domain/usecases/i_remove_favorite_use_case.dart';
import 'package:pokemon_clean_arch/pokemon/domain/usecases/i_save_favorite_use_case.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/favorites/favorite_bloc.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/favorites/favorite_event.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/favorites/favorite_state.dart';

class MockGetFavoritesUseCase extends Mock implements IGetFavoritesUseCase {}

class MockSaveFavoriteUseCase extends Mock implements ISaveFavoriteUseCase {}

class MockRemoveFavoriteUseCase extends Mock
    implements IRemoveFavoriteUseCase {}

class MockAppLogger extends Mock implements AppLogger {}

void main() {
  late FavoriteBloc bloc;
  late MockGetFavoritesUseCase getFavorites;
  late MockSaveFavoriteUseCase saveFavorite;
  late MockRemoveFavoriteUseCase removeFavorite;
  late MockAppLogger logger;

  setUp(() {
    getFavorites = MockGetFavoritesUseCase();
    saveFavorite = MockSaveFavoriteUseCase();
    removeFavorite = MockRemoveFavoriteUseCase();
    logger = MockAppLogger();

    bloc = FavoriteBloc(getFavorites, saveFavorite, removeFavorite, logger);
  });

  setUpAll(() {
    registerFallbackValue(
      PokemonEntity(id: 0, name: 'fallback', imageUrl: ''),
    );
  });

  final tPokemon = PokemonEntity(id: 1, name: 'Bulba', imageUrl: 'url');

  group('FavoriteBloc', () {
    blocTest<FavoriteBloc, FavoriteState>(
      'Should emit [Loading, Loaded] when LoadFavoritesEvent is added',
      build: () {
        when(() => getFavorites()).thenAnswer((_) async => Right([tPokemon]));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadFavoritesEvent()),
      expect: () => [
        FavoriteLoadingState(),
        FavoriteLoadedState(favorites: [tPokemon], favoriteIds: {1}),
      ],
    );

    blocTest<FavoriteBloc, FavoriteState>(
      'Should remove favorite when Toggle is called and item IS favorite',
      build: () {
        when(
          () => removeFavorite(1),
        ).thenAnswer((_) async => const Right(null));
        when(() => getFavorites()).thenAnswer((_) async => const Right([]));

        return bloc;
      },
      seed: () => FavoriteLoadedState(favorites: [tPokemon], favoriteIds: {1}),

      act: (bloc) => bloc.add(ToggleFavoriteEvent(tPokemon)),

      expect: () => [
        FavoriteLoadingState(),
        const FavoriteLoadedState(favorites: [], favoriteIds: {}),
      ],
      verify: (_) {
        verify(() => removeFavorite(1)).called(1);
        verifyNever(() => saveFavorite(any()));
      },
    );
  });
}
