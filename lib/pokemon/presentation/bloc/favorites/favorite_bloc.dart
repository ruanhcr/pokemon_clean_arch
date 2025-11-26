import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pokemon_clean_arch/core/log/app_logger.dart';
import 'package:pokemon_clean_arch/pokemon/domain/usecases/i_get_favorites_use_case.dart';
import 'package:pokemon_clean_arch/pokemon/domain/usecases/i_remove_favorite_use_case.dart';
import 'package:pokemon_clean_arch/pokemon/domain/usecases/i_save_favorite_use_case.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/favorites/favorite_event.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/favorites/favorite_state.dart';

@singleton
class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final IGetFavoritesUseCase _getFavoritesUseCase;
  final ISaveFavoriteUseCase _saveFavoriteUseCase;
  final IRemoveFavoriteUseCase _removeFavoriteUseCase;
  final AppLogger _log;

  FavoriteBloc({
    required IGetFavoritesUseCase getFavoritesUseCase,
    required ISaveFavoriteUseCase saveFavoriteUseCase,
    required IRemoveFavoriteUseCase removeFavoriteUseCase,
    required AppLogger log,
  }) : _getFavoritesUseCase = getFavoritesUseCase,
       _saveFavoriteUseCase = saveFavoriteUseCase,
       _removeFavoriteUseCase = removeFavoriteUseCase,
       _log = log,
       super(FavoriteInitialState()) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }

  Future<void> _onLoadFavorites(
    LoadFavoritesEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    emit(FavoriteLoadingState());

    final result = await _getFavoritesUseCase();

    result.fold(
      (failure) {
        _log.error('Erro ao carregar favoritos', failure);
        emit(const FavoriteErrorState("Erro ao carregar favoritos."));
      },
      (favorites) {
        final ids = favorites.map((e) => e.id).toSet();
        emit(FavoriteLoadedState(favorites: favorites, favoriteIds: ids));
      },
    );
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    if (state is! FavoriteLoadedState) return;

    final currentState = state as FavoriteLoadedState;
    final isFav = currentState.isFavorite(event.pokemon.id);

    final result = isFav
        ? await _removeFavoriteUseCase(event.pokemon.id)
        : await _saveFavoriteUseCase(event.pokemon);

    await result.fold(
      (failure) async {
        _log.error('Erro ao alterar favorito', failure);
      },
      (_) async {
        add(LoadFavoritesEvent());
      },
    );
  }
}
