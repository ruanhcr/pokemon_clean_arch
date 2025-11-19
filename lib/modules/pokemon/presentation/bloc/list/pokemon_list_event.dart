import 'package:equatable/equatable.dart';

sealed class PokemonListEvent extends Equatable {
  const PokemonListEvent();

  @override
  List<Object> get props => [];
}

class FetchPokemonListEvent extends PokemonListEvent {}
