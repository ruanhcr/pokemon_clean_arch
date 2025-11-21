import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pokemon_clean_arch/core/errors/failure_mapper.dart';
import 'package:pokemon_clean_arch/core/log/app_logger.dart';
import 'package:pokemon_clean_arch/pokemon/domain/usecases/i_get_pokemon_details_use_case.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/detail/pokemon_detail_event.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/detail/pokemon_detail_state.dart';

@injectable
class PokemonDetailBloc extends Bloc<PokemonDetailEvent, PokemonDetailState> {
  final IGetPokemonDetailsUseCase useCase;
  final AppLogger log;

  PokemonDetailBloc(this.useCase, this.log) : super(PokemonDetailInitialState()) {
    on<FetchPokemonDetailEvent>(_onFetchPokemonDetail);
  }

  Future<void> _onFetchPokemonDetail(
    FetchPokemonDetailEvent event,
    Emitter<PokemonDetailState> emit,
  ) async {
    emit(PokemonDetailLoadingState());

    final result = await useCase.call(event.id);

    result.fold(
      (failure) {
        final message = failure.uiMessage;
        log.error('Erro nos detalhes', failure);
        emit(PokemonDetailErrorState(message));
      },
      (pokemon) {
        emit(PokemonDetailSuccessState(pokemon));
      },
    );
  }
}
