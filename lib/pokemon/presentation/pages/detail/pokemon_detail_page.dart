import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pokemon_clean_arch/core/ui/styles/app_typography.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_detail_entity.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/detail/pokemon_detail_bloc.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/detail/pokemon_detail_event.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/detail/pokemon_detail_state.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/favorites/favorite_bloc.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/favorites/favorite_event.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/favorites/favorite_state.dart';

class PokemonDetailPage extends StatefulWidget {
  final PokemonDetailBloc? bloc;
  final FavoriteBloc? favoriteBloc;
  final AppTypography? typography;
  final int id;
  const PokemonDetailPage({
    super.key,
    required this.id,
    this.bloc,
    this.favoriteBloc,
    this.typography,
  });

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  late final PokemonDetailBloc bloc;
  late final AppTypography typography;

  @override
  void initState() {
    super.initState();
    bloc = widget.bloc ?? GetIt.I.get<PokemonDetailBloc>();
    typography = widget.typography ?? GetIt.I.get<AppTypography>();
    bloc.add(FetchPokemonDetailEvent(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: Scaffold(
        body: BlocBuilder<PokemonDetailBloc, PokemonDetailState>(
          builder: (context, state) {
            return switch (state) {
              PokemonDetailInitialState() || PokemonDetailLoadingState() =>
                const Center(child: CircularProgressIndicator.adaptive()),
              PokemonDetailErrorState(message: var msg) => Center(
                child: Text(msg),
              ),
              PokemonDetailSuccessState(pokemon: var p) => _buildContent(
                context,
                p,
              ),
            };
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, PokemonDetailEntity pokemon) {
    final Color mainColor = _getColorByType(pokemon.types.first);

    return Stack(
      children: [
        Container(
          color: mainColor,
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
        ),

        Positioned(
          top: -50,
          right: -50,
          child: Icon(
            Icons.catching_pokemon,
            size: 300,
            color: Colors.white.withAlpha((0.15 * 255).round()),
          ),
        ),

        Positioned(
          top: 50,
          left: 16,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),

        Positioned(
          top: 50,
          right: 16,
          child: _FavoriteButton(pokemon: pokemon, bloc: widget.favoriteBloc),
        ),

        Positioned(
          top: 100,
          left: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pokemon.name.toUpperCase(),
                style: typography
                    .heading(24, Colors.white)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Row(
                children: pokemon.types
                    .map(
                      (type) => Container(
                        margin: const EdgeInsets.only(right: 8, top: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha((0.25 * 255).round()),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          type.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),

        Positioned(
          top: 105,
          right: 24,
          child: Text(
            "#${pokemon.id.toString().padLeft(3, '0')}",
            style: typography.body(14, Colors.white, fontWeight: FontWeight.bold),
          ),
        ),

        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 160, 24, 24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildAttributeInfo(
                          "Height",
                          "${pokemon.height / 10} m",
                        ),
                        _buildAttributeInfo(
                          "Weight",
                          "${pokemon.weight / 10} kg",
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    Text(
                      "Base Stats",
                      style: typography.body(20, Colors.black, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildStatRow("HP", pokemon.stats['hp'] ?? 0, Colors.red),
                    _buildStatRow(
                      "Attack",
                      pokemon.stats['attack'] ?? 0,
                      Colors.orange,
                    ),
                    _buildStatRow(
                      "Defense",
                      pokemon.stats['defense'] ?? 0,
                      Colors.blue,
                    ),
                    _buildStatRow(
                      "Speed",
                      pokemon.stats['speed'] ?? 0,
                      Colors.green,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        Positioned(
          top: (MediaQuery.of(context).size.height * 0.4) - 100,
          left: 0,
          right: 0,
          child: Hero(
            tag: pokemon.id,
            child: Image.network(
              pokemon.imageUrl,
              height: 250,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttributeInfo(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildStatRow(String label, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              value.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: value / 100,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorByType(String type) {
    switch (type.toLowerCase()) {
      case 'fire':
        return const Color(0xFFFA6555);
      case 'grass':
        return const Color(0xFF48D0B0);
      case 'water':
        return const Color(0xFF76BCFD);
      case 'electric':
        return const Color(0xFFFFCE4B);
      case 'poison':
        return const Color(0xFFA040A0);
      case 'bug':
        return const Color(0xFFA8B820);
      case 'psychic':
        return const Color(0xFFF85888);
      case 'rock':
        return const Color(0xFFB8A038);
      case 'ground':
        return const Color(0xFFE0C068);
      case 'ghost':
        return const Color(0xFF705898);
      case 'dragon':
        return const Color(0xFF7038F8);
      default:
        return const Color(0xFFA8A77A);
    }
  }
}

class _FavoriteButton extends StatelessWidget {
  final PokemonDetailEntity pokemon;
  final FavoriteBloc? bloc;

  const _FavoriteButton({required this.pokemon, this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      bloc: bloc,
      builder: (context, state) {
        bool isFavorite = false;

        if (state is FavoriteLoadedState) {
          isFavorite = state.isFavorite(pokemon.id);
        }

        return IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            final effectiveBloc = bloc ?? context.read<FavoriteBloc>();
            effectiveBloc.add(ToggleFavoriteEvent(pokemon));
          },
        );
      },
    );
  }
}
