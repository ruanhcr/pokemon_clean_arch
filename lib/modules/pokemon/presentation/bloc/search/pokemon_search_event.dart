import 'package:equatable/equatable.dart';

sealed class PokemonSearchEvent extends Equatable {
  const PokemonSearchEvent();

  @override
  List<Object> get props => [];
}

class SearchPokemonEvent extends PokemonSearchEvent {
  final String name;

  const SearchPokemonEvent(this.name);

  @override
  List<Object> get props => [name];
}
