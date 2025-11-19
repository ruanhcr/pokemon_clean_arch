import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokemon_clean_arch/modules/pokemon/domain/entities/pokemon_entity.dart';
import 'package:pokemon_clean_arch/modules/pokemon/presentation/bloc/search/pokemon_search_bloc.dart';
import 'package:pokemon_clean_arch/modules/pokemon/presentation/bloc/search/pokemon_search_event.dart';
import 'package:pokemon_clean_arch/modules/pokemon/presentation/bloc/search/pokemon_search_state.dart';

class PokemonSearchPage extends StatefulWidget {
  const PokemonSearchPage({super.key});

  @override
  State<PokemonSearchPage> createState() => _PokemonSearchPageState();
}

class _PokemonSearchPageState extends State<PokemonSearchPage> {
  final textController = TextEditingController();
  final bloc = GetIt.I.get<PokemonSearchBloc>();

  @override
  void dispose() {
    textController.dispose();
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: Scaffold(
        backgroundColor: const Color(0xFF212121),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2C3E50),
                Color(0xFF4CA1AF),
              ],
            ),
          ),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                floating: true,
                centerTitle: true,
                title: Text(
                  'PESQUISAR',
                  style: GoogleFonts.pressStart2p(
                    color: Colors.white,
                    fontSize: 16,
                    letterSpacing: 2,
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => context.pop(),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 16),

                    TextField(
                      controller: textController,
                      style: GoogleFonts.poppins(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Nome do Pokémon',
                        labelStyle: GoogleFonts.poppins(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white.withAlpha((0.15 * 255).round()),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white70,
                        ),
                        suffixIcon: ValueListenableBuilder<TextEditingValue>(
                          valueListenable: textController,
                          builder: (context, value, child) {
                            return Visibility(
                              visible: textController.text.isNotEmpty,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                                onPressed: () => textController.clear(),
                              ),
                            );
                          },
                        ),
                      ),
                      onSubmitted: (value) {
                        FocusScope.of(context).unfocus();
                        bloc.add(SearchPokemonEvent(value));
                      },
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          bloc.add(SearchPokemonEvent(textController.text));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFFf7b731,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 8,
                          shadowColor: const Color(
                            0xFFf7b731,
                          ).withAlpha((0.5 * 255).round()),
                        ),
                        child: Text(
                          "BUSCAR",
                          style: GoogleFonts.pressStart2p(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    BlocBuilder<PokemonSearchBloc, PokemonSearchState>(
                      builder: (context, state) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: _buildStateWidget(state),
                        );
                      },
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStateWidget(PokemonSearchState state) {
    Key key;
    Widget content;

    switch (state) {
      case PokemonSearchInitialState():
        key = const ValueKey('initial');
        content = _buildInfoCard(
          icon: Icons.search,
          message: 'Digite o nome do Pokémon para buscar.',
          color: Colors.white70,
        );
        break;

      case PokemonSearchLoadingState():
        key = const ValueKey('loading');
        content = _buildInfoCard(
          isLoading: true,
          message: "Consultando Pokédex...",
          color: Colors.white,
        );
        break;

      case PokemonSearchErrorState(message: var msg):
        key = const ValueKey('error');
        content = _buildInfoCard(
          icon: Icons.error_outline,
          message: msg,
          color: Colors.redAccent,
        );
        break;

      case PokemonSearchSuccessState(pokemon: var p):
        key = ValueKey(p.id);
        content = _buildPokemonCard(p);
        break;
    }
    return SizedBox(key: key, child: content);
  }

  Widget _buildInfoCard({
    IconData? icon,
    required String message,
    required Color color,
    bool isLoading = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha((0.1 * 255).round()),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withAlpha((0.2 * 255).round())),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLoading)
            const CircularProgressIndicator.adaptive()
          else
            Icon(icon, size: 60, color: color),
          const SizedBox(height: 16),
          Text(
            message,
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPokemonCard(PokemonEntity pokemon) {
    final color = _getCardColor(pokemon.id);

    return GestureDetector(
      onTap: () {
        GoRouter.of(context).push('/pokemon/${pokemon.id}');
      },
      child: Container(
        height: 300,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withAlpha((0.9 * 255).round()),
              color.withAlpha((0.6 * 255).round()),
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha((0.4 * 255).round()),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              right: -30,
              bottom: -30,
              child: Icon(
                Icons.catching_pokemon,
                size: 200,
                color: Colors.white.withAlpha((0.2 * 255).round()),
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: pokemon.id,
                  child: Image.network(
                    pokemon.imageUrl,
                    height: 160,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => const Icon(
                      Icons.image_not_supported,
                      size: 80,
                      color: Colors.white54,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  pokemon.name.toUpperCase(),
                  style: GoogleFonts.pressStart2p(
                    fontSize: 24,
                    color: Colors.white,
                    shadows: [
                      const Shadow(
                        offset: Offset(2, 2),
                        blurRadius: 4,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'ID: #${pokemon.id.toString().padLeft(3, '0')}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
