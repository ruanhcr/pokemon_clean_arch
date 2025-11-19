import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pokemon_clean_arch/modules/pokemon/domain/usecases/i_get_pokemon_list_use_case.dart';
import 'package:pokemon_clean_arch/modules/pokemon/presentation/bloc/list/pokemon_list_event.dart';
import 'package:pokemon_clean_arch/modules/pokemon/presentation/bloc/list/pokemon_list_state.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:stream_transform/stream_transform.dart';

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

@injectable
class PokemonListBloc extends Bloc<PokemonListEvent, PokemonListState> {
  final IGetPokemonListUseCase useCase;

  PokemonListBloc(this.useCase) : super(PokemonListInitial()) {
    on<FetchPokemonListEvent>(
      _onFetchPokemonList,
      transformer: throttleDroppable(const Duration(milliseconds: 100)),
    );
  }

  Future<void> _onFetchPokemonList(
    FetchPokemonListEvent event,
    Emitter<PokemonListState> emit,
  ) async {
    if (state is PokemonListSuccess && (state as PokemonListSuccess).hasReachedMax) return;

    try {
      if (state is PokemonListInitial) {
        emit(PokemonListLoading());
        final pokemons = await useCase.call(offset: 0);
        emit(PokemonListSuccess(pokemons: pokemons));
      } 
      
      else if (state is PokemonListSuccess) {
        final currentState = state as PokemonListSuccess;
        final currentOffset = currentState.pokemons.length;
        final newPokemons = await useCase(offset: currentOffset);

        if (newPokemons.isEmpty) {
           emit(currentState.copyWith(hasReachedMax: true));
        } else {
           emit(currentState.copyWith(
             pokemons: currentState.pokemons + newPokemons,
             hasReachedMax: false,
           ));
        }
      }
    } catch (e) {
      emit(PokemonListError("Erro ao carregar lista"));
    }
  }
}
