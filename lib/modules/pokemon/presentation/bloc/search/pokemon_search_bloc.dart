import 'package:injectable/injectable.dart';
import 'package:pokemon_clean_arch/modules/pokemon/domain/usecases/i_get_pokemon_use_case.dart';
import 'package:pokemon_clean_arch/modules/pokemon/presentation/bloc/search/pokemon_search_event.dart';
import 'pokemon_search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@injectable
class PokemonSearchBloc extends Bloc<PokemonSearchEvent, PokemonSearchState> {
  final IGetPokemonUseCase getPokemonUseCase;

  PokemonSearchBloc(this.getPokemonUseCase)
    : super(PokemonSearchInitialState()) {
    on<SearchPokemonEvent>(_onSearch);
  }

  Future<void> _onSearch(
    SearchPokemonEvent event,
    Emitter<PokemonSearchState> emit,
  ) async {
    emit(PokemonSearchLoadingState());
    try {
      final pokemon = await getPokemonUseCase(event.name);
      emit(PokemonSearchSuccessState(pokemon));
    } catch (e) {
      emit(
        const PokemonSearchErrorState(
          "Não conseguimos encontrar esse Pokémon.",
        ),
      );
    }
  }
}
