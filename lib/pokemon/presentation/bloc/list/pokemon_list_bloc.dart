import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pokemon_clean_arch/core/errors/failure.dart';
import 'package:pokemon_clean_arch/core/errors/failure_mapper.dart';
import 'package:pokemon_clean_arch/core/log/app_logger.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_entity.dart';
import 'package:pokemon_clean_arch/pokemon/domain/usecases/i_get_pokemon_list_use_case.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/list/pokemon_list_event.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/list/pokemon_list_state.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:stream_transform/stream_transform.dart';

@injectable
class PokemonListBloc extends Bloc<PokemonListEvent, PokemonListState> {
  final IGetPokemonListUseCase _getPokemonListUseCase;
  final AppLogger _log;

  PokemonListBloc({
    required IGetPokemonListUseCase getPokemonListUseCase,
    required AppLogger log,
  }) : _getPokemonListUseCase = getPokemonListUseCase,
       _log = log,
       super(PokemonListInitialState()) {
    on<FetchPokemonListEvent>(
      _onFetchPokemonList,
      transformer: throttleDroppable(const Duration(milliseconds: 100)),
    );
  }

  Future<void> _onFetchPokemonList(
    FetchPokemonListEvent event,
    Emitter<PokemonListState> emit,
  ) async {
    if (_hasReachedMax(state)) return;

    _emitLoadingIfInitial(state, emit);
    final offset = _calculateCurrentOffset(state);

    final result = await _getPokemonListUseCase(offset: offset);

    result.fold(
      (failure) => _handleFailure(failure, emit),
      (newPokemons) => _handleSuccess(state, newPokemons, emit),
    );
  }

  bool _hasReachedMax(PokemonListState state) {
    return state is PokemonListSuccessState && state.hasReachedMax;
  }

  void _emitLoadingIfInitial(
    PokemonListState state,
    Emitter<PokemonListState> emit,
  ) {
    if (state is PokemonListInitialState) {
      emit(PokemonListLoadingState());
    }
  }

  int _calculateCurrentOffset(PokemonListState state) {
    if (state is PokemonListSuccessState) {
      return state.pokemons.length;
    }
    return 0;
  }

  void _handleFailure(Failure failure, Emitter<PokemonListState> emit) {
    _log.error('Erro na lista', failure);
    emit(PokemonListErrorState(failure.uiMessage));
  }

  void _handleSuccess(
    PokemonListState currentState,
    List<PokemonEntity> newPokemons,
    Emitter<PokemonListState> emit,
  ) {
    if (newPokemons.isEmpty) {
      _handleEmptyResult(currentState, emit);
      return;
    }

    _handleNewData(currentState, newPokemons, emit);
  }

  void _handleEmptyResult(
    PokemonListState currentState,
    Emitter<PokemonListState> emit,
  ) {
    if (currentState is PokemonListSuccessState) {
      emit(currentState.copyWith(hasReachedMax: true));
      return;
    }

    emit(const PokemonListSuccessState(pokemons: []));
  }

  void _handleNewData(
    PokemonListState currentState,
    List<PokemonEntity> newPokemons,
    Emitter<PokemonListState> emit,
  ) {
    final currentList = currentState is PokemonListSuccessState
        ? currentState.pokemons
        : <PokemonEntity>[];

    emit(
      PokemonListSuccessState(
        pokemons: currentList + newPokemons,
        hasReachedMax: false,
      ),
    );
  }
}

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}
