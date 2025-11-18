import 'package:equatable/equatable.dart';

sealed class PokemonEvent extends Equatable {
  const PokemonEvent();
  
  @override
  List<Object> get props => [];
}

class SearchPokemonEvent extends PokemonEvent {
  final String name;

  const SearchPokemonEvent(this.name);

  @override
  List<Object> get props => [name];
}