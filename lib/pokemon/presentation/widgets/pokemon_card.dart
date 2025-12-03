import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokemon_clean_arch/core/ui/extensions/pokemon_color_extension.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_entity.dart';
import '../bloc/favorites/favorite_bloc.dart';
import '../bloc/favorites/favorite_event.dart';

class PokemonCard extends StatelessWidget {
  final PokemonEntity pokemon;
  final bool showFavoriteButton;
  final bool isFeatured;

  const PokemonCard({
    super.key,
    required this.pokemon,
    this.showFavoriteButton = false,
    this.isFeatured = false,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = _buildCardContent(context);

    if (isFeatured) {
      return Center(
        child: Container(
          height: 200,
          margin: const EdgeInsets.only(bottom: 32.0),
          constraints: const BoxConstraints(maxWidth: 400),
          child: cardContent,
        ),
      );
    }

    return cardContent;
  }

  Widget _buildCardContent(BuildContext context) {
    final color = pokemon.cardColor;

    return GestureDetector(
      onTap: () => GoRouter.of(context).push('/pokemon/${pokemon.id}'),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withAlpha((0.9 * 255).round()),
              color.withAlpha((0.7 * 255).round()),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha((0.4 * 255).round()),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -10,
              bottom: -10,
              child: Icon(
                Icons.catching_pokemon,
                size: isFeatured ? 140 : 100,
                color: Colors.white.withAlpha((0.2 * 255).round()),
              ),
            ),

            if (!showFavoriteButton)
              Positioned(top: 10, right: 10, child: _buildIdBadge()),

            if (showFavoriteButton)
              Positioned(top: 8, right: 8, child: _buildRemoveButton()),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showFavoriteButton) const SizedBox(height: 20),

                  Hero(
                    tag: pokemon.id,
                    child: Image.network(
                      pokemon.imageUrl,
                      // Imagem maior no modo Featured
                      height: isFeatured ? 110 : (showFavoriteButton ? 80 : 90),
                      width: isFeatured ? 110 : (showFavoriteButton ? 80 : 90),
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.image_not_supported,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      pokemon.name.toUpperCase(),
                      style: GoogleFonts.pressStart2p(
                        fontSize: isFeatured
                            ? 16
                            : (showFavoriteButton ? 12 : 14),
                        color: Colors.white,
                        shadows: [
                          const Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 2,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  if (showFavoriteButton) ...[
                    const SizedBox(height: 4),
                    _buildIdText(),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIdBadge() {
    return Text(
      "#${pokemon.id.toString().padLeft(3, '0')}",
      style: GoogleFonts.poppins(
        color: Colors.white.withAlpha((0.6 * 255).round()),
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildIdText() {
    return Text(
      "#${pokemon.id.toString().padLeft(3, '0')}",
      style: GoogleFonts.poppins(
        fontSize: 12,
        color: Colors.white70,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildRemoveButton() {
    return GestureDetector(
      onTap: () {
        GetIt.I.get<FavoriteBloc>().add(ToggleFavoriteEvent(pokemon));
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha((0.2 * 255).round()),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.favorite, color: Colors.white, size: 20),
      ),
    );
  }
}
