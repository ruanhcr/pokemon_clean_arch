import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:injectable/injectable.dart';
import 'package:pokemon_clean_arch/core/errors/failure_mapper.dart';
import 'package:pokemon_clean_arch/core/log/app_logger.dart';
import 'package:pokemon_clean_arch/pokemon/domain/usecases/i_search_pokemon_use_case.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/search/pokemon_search_event.dart';
import 'package:stream_transform/stream_transform.dart';
import 'pokemon_search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@injectable
class PokemonSearchBloc extends Bloc<PokemonSearchEvent, PokemonSearchState> {
  final ISearchPokemonUseCase getPokemonUseCase;
  final AppLogger log;

  PokemonSearchBloc(this.getPokemonUseCase, this.log)
    : super(PokemonSearchInitialState()) {
    on<SearchPokemonEvent>(
      _onSearch,
      transformer: debounceRestartable(const Duration(milliseconds: 500)),
    );
  }

  Future<void> _onSearch(
    SearchPokemonEvent event,
    Emitter<PokemonSearchState> emit,
  ) async {
    final query = event.query.trim();

    if (query.isEmpty) {
      emit(PokemonSearchInitialState());
      return;
    }
    emit(PokemonSearchLoadingState());
    final result = await getPokemonUseCase(event.query);

    result.fold(
      (failure) {
        final message = failure.uiMessage;
        log.error('Erro na busca', failure);
        emit(PokemonSearchErrorState(message));
      },
      (pokemon) {
        emit(PokemonSearchSuccessState(pokemon));
      },
    );
  }
}

EventTransformer<E> debounceRestartable<E>(Duration duration) {
  return (events, mapper) {
    return restartable<E>().call(events.debounce(duration), mapper);
  };
}
