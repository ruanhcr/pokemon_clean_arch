import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_entity.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/list/pokemon_list_bloc.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/list/pokemon_list_event.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/list/pokemon_list_state.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/widgets/pokemon_grid_skeleton.dart';

class PokemonListPage extends StatefulWidget {
  const PokemonListPage({super.key, this.bloc});
  final PokemonListBloc? bloc;

  @override
  State<PokemonListPage> createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  late final PokemonListBloc bloc;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    bloc = widget.bloc ?? GetIt.I.get<PokemonListBloc>();
    bloc.add(FetchPokemonListEvent());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) bloc.add(FetchPokemonListEvent());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 200);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: Scaffold(
        backgroundColor: const Color(0xFF212121),
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: const Color(0xFF212121),
              expandedHeight: 100,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  'POKÉDEX',
                  style: GoogleFonts.pressStart2p(
                    color: Colors.white,
                    fontSize: 16,
                    letterSpacing: 2,
                  ),
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha((0.1 * 255).round()),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () => GoRouter.of(context).push('/search'),
                  ),
                ),
              ],
            ),

            BlocBuilder<PokemonListBloc, PokemonListState>(
              builder: (context, state) {
                return switch (state) {
                  PokemonListInitialState() ||
                  PokemonListLoadingState() => const PokemonGridSkeleton(),
                  PokemonListErrorState(message: var msg) =>
                    SliverFillRemaining(
                      child: Center(
                        child: Text(
                          msg,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  PokemonListSuccessState(
                    pokemons: var list,
                    hasReachedMax: var hasMax,
                  ) =>
                    SliverPadding(
                      padding: const EdgeInsets.all(12),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.85,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          if (index >= list.length) {
                            return const Center(
                              child: CircularProgressIndicator.adaptive(),
                            );
                          }

                          final pokemon = list[index];
                          return _buildPokemonCard(context, pokemon);
                        }, childCount: hasMax ? list.length : list.length + 1),
                      ),
                    ),
                };
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPokemonCard(BuildContext context, PokemonEntity pokemon) {
    final color = _getCardColor(pokemon.id);

    return GestureDetector(
      onTap: () => GoRouter.of(context).push('/pokemon/${pokemon.id}'),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withAlpha((0.8 * 255).round()),
              color.withAlpha((0.6 * 255).round()),
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
                size: 100,
                color: Colors.white.withAlpha((0.2 * 255).round()),
              ),
            ),

            Positioned(
              top: 10,
              right: 10,
              child: Text(
                "#${pokemon.id.toString().padLeft(3, '0')}",
                style: GoogleFonts.poppins(
                  color: Colors.white.withAlpha((0.6 * 255).round()),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: pokemon.id,
                  child: Image.network(
                    pokemon.imageUrl,
                    height: 90,
                    width: 90,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => const Icon(
                      Icons.image_not_supported,
                      color: Colors.white54,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  pokemon.name.toUpperCase(),
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    shadows: [
                      const Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 2,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getCardColor(int id) {
    final colors = [
      const Color(0xFF48D0B0),
      const Color(0xFFFA6555),
      const Color(0xFF76BCFD),
      const Color(0xFFFFCE4B),
      const Color(0xFF9F5BBA),
      const Color(0xFFCA8179),
    ];
    return colors[id % colors.length];
  }
}
