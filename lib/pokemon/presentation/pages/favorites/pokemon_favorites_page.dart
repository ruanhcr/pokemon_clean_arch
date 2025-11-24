import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/favorites/favorite_bloc.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/favorites/favorite_state.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/widgets/pokemon_card.dart';

class PokemonFavoritesPage extends StatelessWidget {
  const PokemonFavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteBloc = GetIt.I.get<FavoriteBloc>();

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
                style: GoogleFonts.pressStart2p(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),

            BlocBuilder<FavoriteBloc, FavoriteState>(
              bloc: favoriteBloc,
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
                          style: GoogleFonts.poppins(color: Colors.white70),
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
                      return PokemonCard(pokemon: pokemon, showFavoriteButton: true,);
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
