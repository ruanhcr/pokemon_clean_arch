import 'package:equatable/equatable.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_entity.dart';

sealed class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

class LoadFavoritesEvent extends FavoriteEvent {}

class ToggleFavoriteEvent extends FavoriteEvent {
  final PokemonEntity pokemon;

  const ToggleFavoriteEvent(this.pokemon);

  @override
  List<Object> get props => [pokemon];
}
