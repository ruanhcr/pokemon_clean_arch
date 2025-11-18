import 'package:injectable/injectable.dart';
import 'package:pokemon_clean_arch/modules/pokemon/domain/usecases/get_pokemon_use_case.dart';
import 'package:pokemon_clean_arch/modules/pokemon/presentation/bloc/pokemon_event.dart';
import 'pokemon_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@injectable
class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final IGetPokemonUseCase getPokemonUseCase;

  PokemonBloc(this.getPokemonUseCase) : super(PokemonInitialState()) {
    on<SearchPokemonEvent>(_onSearch);
  }

  Future<void> _onSearch(
    SearchPokemonEvent event,
    Emitter<PokemonState> emit,
  ) async {
    emit(PokemonLoadingState());

    try {
      final pokemon = await getPokemonUseCase(event.name);
      emit(PokemonSuccessState(pokemon));
    } catch (e) {
      emit(const PokemonErrorState("Não conseguimos encontrar esse Pokémon."));
    }
  }
}
