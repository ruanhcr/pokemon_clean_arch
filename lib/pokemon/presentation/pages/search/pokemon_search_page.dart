import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemon_clean_arch/core/ui/styles/app_typography.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/search/pokemon_search_bloc.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/search/pokemon_search_event.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/search/pokemon_search_state.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/widgets/pokemon_card.dart';

class PokemonSearchPage extends StatefulWidget {
  const PokemonSearchPage({super.key, this.bloc, this.typography});
  final PokemonSearchBloc? bloc;
  final AppTypography? typography;

  @override
  State<PokemonSearchPage> createState() => _PokemonSearchPageState();
}

class _PokemonSearchPageState extends State<PokemonSearchPage> {
  final textController = TextEditingController();
  late final PokemonSearchBloc bloc;
  late final AppTypography typography;

  @override
  void initState() {
    super.initState();
    bloc = widget.bloc ?? GetIt.I.get<PokemonSearchBloc>();
    typography = widget.typography ?? GetIt.I.get<AppTypography>();
  }

  @override
  void dispose() {
    textController.dispose();
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
              colors: [Color(0xFF2C3E50), Color(0xFF4CA1AF)],
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
                  style: typography.heading(16, Colors.white),
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
                      style: typography.body(16, Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Nome do Pokémon',
                        labelStyle: typography.body(16, Colors.white70),
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
                      onChanged: (value) {
                        bloc.add(SearchPokemonEvent(value));
                      },
                      onSubmitted: (value) {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    const SizedBox(height: 24),

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
          message: 'Digite o nome do Pokémon para buscar',
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

        final isNotFound = msg.contains("Não encontramos");

        content = _buildInfoCard(
          icon: isNotFound ? Icons.search_off : Icons.error_outline,
          message: msg,
          color: isNotFound ? Colors.orangeAccent : Colors.redAccent,
        );
        break;

      case PokemonSearchSuccessState(pokemon: var p):
        key = ValueKey(p.id);
        content = PokemonCard(pokemon: p, isFeatured: true,);
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
            style: typography.body(16, Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
