import 'package:equatable/equatable.dart';

sealed class PokemonSearchEvent extends Equatable {
  const PokemonSearchEvent();

  @override
  List<Object> get props => [];
}

class SearchPokemonEvent extends PokemonSearchEvent {
  final String query;

  const SearchPokemonEvent(this.query);

  @override
  List<Object> get props => [query];
}
