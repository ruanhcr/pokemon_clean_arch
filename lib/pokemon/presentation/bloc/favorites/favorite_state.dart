import 'package:equatable/equatable.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_entity.dart';

sealed class FavoriteState extends Equatable {
  const FavoriteState();
  
  @override
  List<Object> get props => [];
}

class FavoriteInitialState extends FavoriteState {}
class FavoriteLoadingState extends FavoriteState {}

class FavoriteLoadedState extends FavoriteState {
  final List<PokemonEntity> favorites;
  final Set<int> favoriteIds; 

  const FavoriteLoadedState({
    required this.favorites,
    required this.favoriteIds,
  });

  bool isFavorite(int id) => favoriteIds.contains(id);

  @override
  List<Object> get props => [favorites, favoriteIds];
}

class FavoriteErrorState extends FavoriteState {
  final String message;
  const FavoriteErrorState(this.message);
  
  @override
  List<Object> get props => [message];
}