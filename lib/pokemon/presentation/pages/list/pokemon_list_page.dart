import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemon_clean_arch/core/ui/styles/app_typography.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/favorites/favorite_bloc.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/favorites/favorite_state.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/list/pokemon_list_bloc.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/list/pokemon_list_event.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/list/pokemon_list_state.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/widgets/pokemon_card.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/widgets/pokemon_grid_skeleton.dart';

class PokemonListPage extends StatefulWidget {
  final PokemonListBloc? bloc;
  final AppTypography? typography;
  const PokemonListPage({super.key, this.bloc, this.typography});

  @override
  State<PokemonListPage> createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  late final PokemonListBloc bloc;
  late final AppTypography typography;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    bloc = widget.bloc ?? GetIt.I.get<PokemonListBloc>();
    typography = widget.typography ?? GetIt.I.get<AppTypography>();
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
                  style: typography.heading(16, Colors.white),
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
                BlocBuilder<FavoriteBloc, FavoriteState>(
                  bloc: GetIt.I.get<FavoriteBloc>(),
                  builder: (context, state) {
                    final count = (state is FavoriteLoadedState)
                        ? state.favorites.length
                        : 0;

                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.favorite, color: Colors.white),
                          onPressed: () =>
                              GoRouter.of(context).push('/favorites'),
                        ),
                        if (count > 0)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '$count',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(width: 8),
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
                          return PokemonCard(pokemon: pokemon);
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
}
