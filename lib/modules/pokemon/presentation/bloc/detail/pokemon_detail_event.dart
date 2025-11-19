import 'package:equatable/equatable.dart';

sealed class PokemonDetailEvent extends Equatable {
  const PokemonDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchPokemonDetailEvent extends PokemonDetailEvent {
  final int id;
  const FetchPokemonDetailEvent(this.id);

  @override
  List<Object> get props => [id];
}
