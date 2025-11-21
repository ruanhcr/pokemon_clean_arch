import 'package:equatable/equatable.dart';

import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_entity.dart';

sealed class PokemonListState extends Equatable {
  const PokemonListState();

  @override
  List<Object> get props => [];
}

class PokemonListInitialState extends PokemonListState {}

class PokemonListLoadingState extends PokemonListState {}

class PokemonListSuccessState extends PokemonListState {
  final List<PokemonEntity> pokemons;
  final bool hasReachedMax;

  const PokemonListSuccessState({
    required this.pokemons,
    this.hasReachedMax = false,
  });

  @override
  List<Object> get props => [pokemons, hasReachedMax];

  PokemonListSuccessState copyWith({
    List<PokemonEntity>? pokemons,
    bool? hasReachedMax,
  }) {
    return PokemonListSuccessState(
      pokemons: pokemons ?? this.pokemons,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class PokemonListErrorState extends PokemonListState {
  final String message;
  const PokemonListErrorState(this.message);

  @override
  List<Object> get props => [];
}
