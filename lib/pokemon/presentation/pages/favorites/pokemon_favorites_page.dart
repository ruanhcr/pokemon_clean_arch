import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemon_clean_arch/core/ui/styles/app_typography.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/favorites/favorite_bloc.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/favorites/favorite_state.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/widgets/pokemon_card.dart';

class PokemonFavoritesPage extends StatefulWidget {
  final FavoriteBloc? bloc;
  final AppTypography? typography;
  const PokemonFavoritesPage({super.key, this.bloc, this.typography});

  @override
  State<PokemonFavoritesPage> createState() => _PokemonFavoritesPageState();
}

class _PokemonFavoritesPageState extends State<PokemonFavoritesPage> {
  late final FavoriteBloc bloc;
  late final AppTypography typography;

  @override
  void initState() {
    super.initState();
    bloc = widget.bloc ?? GetIt.I.get<FavoriteBloc>();
    typography = widget.typography ?? GetIt.I.get<AppTypography>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212121),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF212121), Color(0xFF373737)],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              floating: true,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => context.pop(),
              ),
              title: Text(
                'MEUS FAVORITOS',
                style: typography.heading(16, Colors.white),
              ),
            ),

            BlocBuilder<FavoriteBloc, FavoriteState>(
              bloc: bloc,
              builder: (context, state) {
                if (state is! FavoriteLoadedState || state.favorites.isEmpty) {
                  return SliverFillRemaining(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 80,
                          color: Colors.white.withAlpha((0.3 * 255).round()),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Nenhum favorito ainda",
                          style: typography.body(16, Colors.white70),
                        ),
                      ],
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.all(12),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.80,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final pokemon = state.favorites[index];
                      return PokemonCard(
                        pokemon: pokemon,
                        showFavoriteButton: true,
                      );
                    }, childCount: state.favorites.length),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
