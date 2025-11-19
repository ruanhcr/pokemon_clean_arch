import 'package:equatable/equatable.dart';
import 'package:pokemon_clean_arch/modules/pokemon/domain/entities/pokemon_entity.dart';

sealed class PokemonSearchState extends Equatable {
  const PokemonSearchState();

  @override
  List<Object?> get props => [];
}

class PokemonSearchInitialState extends PokemonSearchState {}

class PokemonSearchLoadingState extends PokemonSearchState {}

class PokemonSearchSuccessState extends PokemonSearchState {
  final PokemonEntity pokemon;

  const PokemonSearchSuccessState(this.pokemon);

  @override
  List<Object> get props => [pokemon];
}

class PokemonSearchErrorState extends PokemonSearchState {
  final String message;

  const PokemonSearchErrorState(this.message);

  @override
  List<Object> get props => [message];
}
