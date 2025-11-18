
import 'package:equatable/equatable.dart';
import 'package:pokemon_clean_arch/modules/pokemon/domain/entities/pokemon_entity.dart';

sealed class PokemonState extends Equatable {
  const PokemonState();
  
  @override
  List<Object?> get props => [];
}

class PokemonInitialState extends PokemonState {}

class PokemonLoadingState extends PokemonState {}

class PokemonSuccessState extends PokemonState {
  final PokemonEntity pokemon;

  const PokemonSuccessState(this.pokemon);

  @override
  List<Object> get props => [pokemon];
}

class PokemonErrorState extends PokemonState {
  final String message;

  const PokemonErrorState(this.message);

  @override
  List<Object> get props => [message];
}