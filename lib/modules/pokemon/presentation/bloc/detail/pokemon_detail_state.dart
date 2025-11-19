import 'package:equatable/equatable.dart';
import 'package:pokemon_clean_arch/modules/pokemon/domain/entities/pokemon_detail_entity.dart';

sealed class PokemonDetailState extends Equatable {
  const PokemonDetailState();

  @override
  List<Object> get props => [];
}

class PokemonDetailInitial extends PokemonDetailState {}

class PokemonDetailLoading extends PokemonDetailState {}

class PokemonDetailSuccess extends PokemonDetailState {
  final PokemonDetailEntity pokemon;

  const PokemonDetailSuccess(this.pokemon);

  @override
  List<Object> get props => [pokemon];
}

class PokemonDetailError extends PokemonDetailState {
  final String message;
  const PokemonDetailError(this.message);
  
  @override
  List<Object> get props => [message];
}