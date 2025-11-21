import 'package:equatable/equatable.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_detail_entity.dart';

sealed class PokemonDetailState extends Equatable {
  const PokemonDetailState();

  @override
  List<Object> get props => [];
}

class PokemonDetailInitialState extends PokemonDetailState {}

class PokemonDetailLoadingState extends PokemonDetailState {}

class PokemonDetailSuccessState extends PokemonDetailState {
  final PokemonDetailEntity pokemon;

  const PokemonDetailSuccessState(this.pokemon);

  @override
  List<Object> get props => [pokemon];
}

class PokemonDetailErrorState extends PokemonDetailState {
  final String message;
  const PokemonDetailErrorState(this.message);

  @override
  List<Object> get props => [message];
}