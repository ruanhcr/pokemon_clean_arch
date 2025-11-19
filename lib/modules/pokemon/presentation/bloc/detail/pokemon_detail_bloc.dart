import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pokemon_clean_arch/modules/pokemon/domain/usecases/i_get_pokemon_details_use_case.dart';
import 'package:pokemon_clean_arch/modules/pokemon/presentation/bloc/detail/pokemon_detail_event.dart';
import 'package:pokemon_clean_arch/modules/pokemon/presentation/bloc/detail/pokemon_detail_state.dart';

@injectable
class PokemonDetailBloc extends Bloc<PokemonDetailEvent, PokemonDetailState> {
  final IGetPokemonDetailsUseCase useCase;
  
  PokemonDetailBloc(this.useCase) : super(PokemonDetailInitial()) {
    on<FetchPokemonDetailEvent>(_onFetchPokemonDetail);
  }

  Future<void> _onFetchPokemonDetail(
    FetchPokemonDetailEvent event,
    Emitter<PokemonDetailState> emit,
  ) async {
    emit(PokemonDetailLoading());
    try {
      final pokemon = await useCase.call(event.id);
      emit(PokemonDetailSuccess(pokemon));
    } catch (e) {
      emit(const PokemonDetailError("Não conseguimos encontrar os detalhes desse Pokémon."));
    }
  }
}
