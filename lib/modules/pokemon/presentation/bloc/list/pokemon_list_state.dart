// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:pokemon_clean_arch/modules/pokemon/domain/entities/pokemon_entity.dart';

sealed class PokemonListState extends Equatable {
  const PokemonListState();

  @override
  List<Object> get props => [];
}

class PokemonListInitial extends PokemonListState {}

class PokemonListLoading extends PokemonListState {}

class PokemonListSuccess extends PokemonListState {
  final List<PokemonEntity> pokemons;
  final bool hasReachedMax;

  const PokemonListSuccess({
    required this.pokemons,
    this.hasReachedMax = false,
  });

  @override
  List<Object> get props => [pokemons, hasReachedMax];

  PokemonListSuccess copyWith({
    List<PokemonEntity>? pokemons,
    bool? hasReachedMax,
  }) {
    return PokemonListSuccess(
      pokemons: pokemons ?? this.pokemons,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class PokemonListError extends PokemonListState {
  final String message;
  const PokemonListError(this.message);

  @override
  List<Object> get props => [];
}
